import 'package:expense_tracker/modules/api/getCategories/GetCategoriesApi.dart';
import 'package:expense_tracker/modules/api/getItems/GetItemsApi.dart';
import 'package:expense_tracker/modules/api/getRecords/GetRecordsApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/models/ExpenseChartData.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/modules/models/static/RecordGroupMaker.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonGroup.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ExpenseChart.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/NavMenuBar.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:expense_tracker/ui/components/screens/home/CategoryListDisplay.dart';
import 'package:expense_tracker/ui/components/screens/home/TotalSpentDisplay.dart';
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

  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);
  UserState get userState => Provider.of<UserState>(context, listen: false);

  /// Returns the uid of the current online user.
  String get uid => userState.user.value.uid;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadData();
    });
  }

  /// Loads all data necessary to display the record data.
  Future loadData() async {
    final loader = showLoader(context);

    try {
      final categories = await _retrieveCategories();
      final items = await _retrieveItems();
      final records = await _retrieveRecords();
      setState(() {
        this.recordGroups = RecordGroupMaker.make(categories, items, records);
      });
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Sets the specified date range for data displayal.
  void setDateRange(DateRangeType type) {
    setState(() => dateRangeType = type);
    loadData();
  }

  /// Shows the record page to start recording a new item.
  Future showRecordPage() async {
    try {
      await appNavigation.toRecordCategoryPage(context);
      loadData();
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Shows the detail screen using the specified record group.
  void showDetailScreen(RecordGroup recordGroup) {
    // TODO: Navigate to DetailScreen. Pass the category and date range type.
  }

  /// Returns the total amount of money used.
  double getTotalUsage() {
    double usage = 0;
    for(final group in recordGroups) {
      usage += group.totalAmount;
    }
    return usage;
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
      body: FilledBox(
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
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 300, maxWidth: 400),
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
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: 300,
                  ),
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
    );
  }

  /// Returns a future which loads all categories in the db.
  Future<List<Category>> _retrieveCategories() {
    return GetCategoriesApi(uid).request();
  }

  /// Returns a future which loads all items in the db.
  Future<List<Item>> _retrieveItems() {
    return GetItemsApi(uid).request();
  }

  /// Returns a future which loads all records matching the current state from the db.
  Future<List<Record>> _retrieveRecords() {
    final range = DateRange(DateTime.now(), dateRangeType);
    return GetRecordsApi(uid).afterDate(range.min).beforeDate(range.max).request();
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
    showDetailScreen(recordGroup);
  }
}
