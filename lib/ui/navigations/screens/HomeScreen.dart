import 'package:expense_tracker/modules/api/getCategories/GetCategoriesApi.dart';
import 'package:expense_tracker/modules/api/getRecords/GetRecordsApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/BudgetState.dart';
import 'package:expense_tracker/modules/dependencies/Prefs.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/models/ExpenseChartData.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/modules/models/static/BudgetCalculator.dart';
import 'package:expense_tracker/modules/models/static/RecordGroupMaker.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonGroup.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonWidthConstraint.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ExpenseChart.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/NavMenuBar.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:expense_tracker/ui/components/screens/home/CategoryListDisplay.dart';
import 'package:expense_tracker/ui/components/primitives/TotalSpentDisplay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with UtilMixin, SnackbarMixin, LoaderMixin {
  DateRangeType dateRangeType = DateRangeType.day;
  List<RecordGroup> recordGroups = [];

  Prefs get prefs => Provider.of<Prefs>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);
  UserState get userState => Provider.of<UserState>(context, listen: false);
  BudgetState get budgetState => Provider.of<BudgetState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      dateRangeType = prefs.lastDateRangeType;

      loadData();
      loadBudget();
    });
  }

  /// Loads all data necessary to display the record data.
  Future loadData() async {
    final loader = showLoader(context);

    try {
      final categories = await _retrieveCategories();
      final records = await _retrieveRecords();
      setState(() {
        this.recordGroups = RecordGroupMaker.make(categories, records);
      });
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Loads the budget data from the server.
  Future loadBudget() async {
    final loader = showLoader(context);

    try {
      await Future.wait([
        budgetState.loadBudget(userState.uid),
        budgetState.loadSpecialBudgets(userState.uid),
      ]);
      setState(() {});
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Sets the specified date range for data displayal.
  void setDateRange(DateRangeType type) {
    setState(() => dateRangeType = type);
    prefs.lastDateRangeType = type;
    loadData();
  }

  /// Shows the record page to start recording a new record.
  Future showRecordPage() async {
    await appNavigation.toRecordCategoryPage(context);
    loadData();
  }

  /// Shows the detail page using the specified record group.
  Future showDetailPage(RecordGroup recordGroup) async {
    await appNavigation.toRecordGroupDetailPage(context, recordGroup);
    loadData();
  }

  /// Returns the total amount of money used.
  double getTotalUsage() {
    double usage = 0;
    for (final group in recordGroups) {
      usage += group.totalAmount;
    }
    return usage;
  }

  /// Returns the budget of the current date range.
  double getBudget() {
    return BudgetCalculator.getTotalBudget(
      budgetState.defaultBudget,
      budgetState.specialBudgets,
      DateRange.withDateRange(DateTime.now().toUtc(), dateRangeType),
    );
  }

  /// Returns the data for the chart to display.
  List<ExpenseChartData> getChartData() {
    return recordGroups.map((e) {
      Color color = Color(e.category.color);
      return ExpenseChartData(color: color, label: e.category.name, value: e.totalAmount);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavMenuBar(
        curScreenType: NavMenuScreenType.home,
      ),
      body: SafeArea(
        child: FilledBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: ContentPadding(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TitleText("Overview"),
                        ButtonGroup(
                          [
                            "Day",
                            "Week",
                            "Month",
                            "Year",
                          ],
                          selectedIndex: dateRangeType.index,
                          onSelection: _onDateTypeSelection,
                        ),
                        SizedBox(height: 20),
                        TotalSpentDisplay(
                          dateRangeType: dateRangeType,
                          amount: getTotalUsage(),
                          budget: getBudget(),
                        ),
                        SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 400),
                          child: ExpenseChart(
                            data: getChartData(),
                          ),
                        ),
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 400,
                          ),
                          child: CategoryListDisplay(
                            recordGroups: recordGroups,
                            onClick: _onCategoryButton,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BottomContentPadding(
                child: ContentPadding(
                  child: ButtonWidthConstraint(
                    child: RoundedButton(
                      isFullWidth: true,
                      onClick: _onRecordButton,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(IconAtlas.record, color: theme.scaffoldBackgroundColor),
                          SizedBox(width: 8),
                          Text("Record new", style: TextStyle(color: theme.scaffoldBackgroundColor)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns a future which loads all categories in the db.
  Future<List<Category>> _retrieveCategories() {
    return GetCategoriesApi(userState.uid).request();
  }

  /// Returns a future which loads all records matching the current state from the db.
  Future<List<Record>> _retrieveRecords() {
    final range = DateRange.withDateRange(DateTime.now(), dateRangeType);
    return GetRecordsApi(userState.uid).afterDate(range.min).beforeDate(range.max).request();
  }

  /// Event called on selecting a date range type.
  void _onDateTypeSelection(int index) {
    setDateRange(DateRangeType.values[index]);
  }

  /// Event called on record new button.
  void _onRecordButton() {
    showRecordPage();
  }

  /// Event called on category button click.
  void _onCategoryButton(RecordGroup recordGroup) {
    showDetailPage(recordGroup);
  }
}
