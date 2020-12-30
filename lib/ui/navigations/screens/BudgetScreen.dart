import 'package:expense_tracker/modules/api/getRecords/GetRecordsApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/BudgetState.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/DialogMixin.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';
import 'package:expense_tracker/modules/models/static/BudgetCalculator.dart';
import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/models/ExpenseChartData.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonWidthConstraint.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ExpenseChart.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/NavMenuBar.dart';
import 'package:expense_tracker/ui/components/primitives/SectionText.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:expense_tracker/ui/navigations/popups/BudgetSetupPopup.dart';
import 'package:expense_tracker/ui/navigations/pages/SpecialBudgetsPage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with UtilMixin, SnackbarMixin, LoaderMixin, DialogMixin {
  List<Record> records = [];
  bool isDataCached = false;
  Map<DateRangeType, double> totalBudgets = {};
  Map<DateRangeType, double> totalSpends = {};

  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);
  UserState get userState => Provider.of<UserState>(context, listen: false);
  BudgetState get budgetState => Provider.of<BudgetState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadBudgetData();
    });
  }

  /// Loads budget data from server.
  Future loadBudgetData() async {
    final loader = showLoader(context);

    try {
      await Future.wait([
        budgetState.loadBudget(userState.uid),
        budgetState.loadSpecialBudgets(userState.uid),
        _loadRecords(),
      ]);
      _cacheTotalBudgetAndSpends();
      setState(() {});
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Starts a new budget set up process for the user.
  Future setupBudget() async {
    try {
      final newBudget = await showDialogDefault<DefaultBudget>(context, BudgetSetupPopup());
      if (newBudget != null) {
        setState(() => budgetState.defaultBudget = newBudget);
        _cacheTotalBudgetAndSpends();
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Starts a new special budget set up process for the user.
  Future setupSpecials() async {
    try {
      await appNavigation.toSpecialBudgetsPage(context);
      loadBudgetData();
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Returns the chart data for the specified range type.
  List<ExpenseChartData> getChartData(DateRangeType rangeType) {
    double totalSpent = totalSpends[rangeType];
    double totalBudget = totalBudgets[rangeType];
    List<ExpenseChartData> chartData = [];
    if (totalSpent > 0) {
      chartData.add(ExpenseChartData(
        label: "Used",
        color: Theme.of(context).errorColor,
        value: totalSpent,
      ));
    }
    if (totalSpent < totalBudget) {
      chartData.add(ExpenseChartData(
        label: "Remaining",
        color: Theme.of(context).primaryColor,
        value: totalBudget - totalSpent,
      ));
    }
    return chartData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavMenuBar(
        curScreenType: NavMenuScreenType.budget,
      ),
      body: SafeArea(
        child: FilledBox(
          child: SingleChildScrollView(
            child: ContentPadding(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TitleText("Budget"),
                  budgetState.isBudgetSetup ? _drawBudgetContent() : _drawNoBudgetContent(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Draws the content for when the user does not have a budget set up.
  Widget _drawNoBudgetContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("There is no budget set up."),
        SizedBox(height: 10),
        Text(
          "With this feature, you can easily track how much you are planning to use, have used, and can safely use.",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        TextRoundedButton(
          "Set up budget",
          onClick: _onSetupBudgetButton,
        )
      ],
    );
  }

  /// Draws the content for when the user has a budget set up.
  Widget _drawBudgetContent() {
    if (!isDataCached) {
      return Container();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SectionText(
          "Weekly budget (\$${totalBudgets[DateRangeType.week].toStringAsFixed(2)})",
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: ExpenseChart(
            data: getChartData(DateRangeType.week),
            showLegends: true,
          ),
        ),
        SizedBox(height: 30),
        SectionText(
          "Monthly budget (\$${totalBudgets[DateRangeType.month].toStringAsFixed(2)})",
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: ExpenseChart(
            data: getChartData(DateRangeType.month),
            showLegends: true,
          ),
        ),
        SizedBox(height: 30),
        SectionText(
          "Yearly budget (\$${totalBudgets[DateRangeType.year].toStringAsFixed(2)})",
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 400),
          child: ExpenseChart(
            data: getChartData(DateRangeType.year),
            showLegends: true,
          ),
        ),
        SizedBox(height: 30),
        ButtonWidthConstraint(
          child: TextRoundedButton(
            "Set special budgets",
            isFullWidth: true,
            onClick: _onSpecialBudgetButton,
          ),
        ),
        SizedBox(height: 10),
        ButtonWidthConstraint(
          child: TextRoundedButton(
            "Change default budget",
            isFullWidth: true,
            isOutlined: true,
            onClick: _onChangeBudgetButton,
          ),
        ),
        SizedBox(height: 40),
      ],
    );
  }

  /// Loads the list of records and assigns to state.
  /// May throw an error.
  Future _loadRecords() async {
    final afterDate = DateTime.utc(DateTime.now().toUtc().year);
    final api = GetRecordsApi(userState.uid).afterDate(afterDate);
    final records = await api.request();
    setState(() => this.records = records);
  }

  /// Returns the total amount spent for the specified records.
  double _getTotalSpent(Iterable<Record> records) {
    double amount = 0;
    for (final record in records) {
      amount += record.price;
    }
    return amount;
  }

  /// Calculates the total budget and spends for each date range type.
  void _cacheTotalBudgetAndSpends() {
    if (budgetState.isBudgetSetup) {
      for (final type in DateRangeType.values) {
        final dateRange = DateRange.withDateRange(DateTime.now().toUtc(), type);
        totalSpends[type] = _getTotalSpent(
          records.where((element) => !element.date.isBefore(dateRange.min)).toList(),
        );
        totalBudgets[type] = BudgetCalculator.getTotalBudget(
          budgetState.defaultBudget,
          budgetState.specialBudgets,
          dateRange,
        );
      }
      setState(() => isDataCached = true);
    }
  }

  /// Event called when the budget setup button was clicked.
  void _onSetupBudgetButton() {
    setupBudget();
  }

  /// Event called when the special budget button was clicked.
  void _onSpecialBudgetButton() {
    setupSpecials();
  }

  /// Event called when the budget change button was clicked.
  void _onChangeBudgetButton() {
    setupBudget();
  }
}
