import 'package:expense_tracker/modules/api/get_categories/get_categories_api.dart';
import 'package:expense_tracker/modules/api/get_records/get_records_api.dart';
import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/budget_state.dart';
import 'package:expense_tracker/modules/dependencies/prefs.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/date_range.dart';
import 'package:expense_tracker/modules/models/expense_chart_data.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/record_group.dart';
import 'package:expense_tracker/modules/models/static/budget_calculator.dart';
import 'package:expense_tracker/modules/models/static/record_group_maker.dart';
import 'package:expense_tracker/modules/themes/icon_atlas.dart';
import 'package:expense_tracker/modules/types/date_range_type.dart';
import 'package:expense_tracker/modules/types/nav_menu_screen_type.dart';
import 'package:expense_tracker/ui/components/primitives/bottom_content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/buttom_group.dart';
import 'package:expense_tracker/ui/components/primitives/button_with_constraint.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/expense_chart.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/nav_menu_bar.dart';
import 'package:expense_tracker/ui/components/primitives/rounded_button.dart';
import 'package:expense_tracker/ui/components/primitives/title_text.dart';
import 'package:expense_tracker/ui/components/screens/home/category_list_display.dart';
import 'package:expense_tracker/ui/components/primitives/total_spent_display.dart';
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
