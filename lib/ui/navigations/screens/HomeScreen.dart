import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/ExpenseChartData.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
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

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateRangeType dateRangeType = DateRangeType.day;

  /// Sets the specified date range for data displayal.
  void setDateRange(DateRangeType type) {
    setState(() => dateRangeType = type);
  }

  /// Shows the record page to start recording a new item.
  void showRecordPage() {
    // TODO: Navigate to RecordPage.
  }

  /// Shows the detail screen using the specified record group.
  void showDetailScreen(RecordGroup recordGroup) {
    // TODO: Navigate to DetailScreen. Pass the category and date range type.
  }

  /// Returns the list of record groups evaluated from current state.
  List<RecordGroup> getRecordGroups() {
    // TODO: Use actual data.
    return [
      RecordGroup(
        category: Category(id: "a", name: "Food", color: 0xffff8888),
        records: [
          Record(itemId: "a", quantity: 1, unitPrice: 5),
          Record(itemId: "a", quantity: 2, unitPrice: 4),
          Record(itemId: "a", mass: 1.5, unitPrice: 4),
        ],
      ),
      RecordGroup(
        category: Category(id: "a", name: "Game", color: 0xff88ff88),
        records: [
          Record(itemId: "a", quantity: 1, unitPrice: 4.99),
          Record(itemId: "a", quantity: 2, unitPrice: 6.99),
          Record(itemId: "a", quantity: 1, unitPrice: 3.5),
        ],
      )
    ];
  }

  /// Returns the data for the chart to display.
  List<ExpenseChartData> getChartData() {
    return getRecordGroups().map((e) {
      Color color = Color(e.category.color);
      return ExpenseChartData(color: color, label: e.category.name, value: e.totalAmount);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
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
                        // TODO: Use real amount
                        amount: 0,
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
                          recordGroups: getRecordGroups(),
                          onClick: _onCategoryButton,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            ContentPadding(
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
                      Icon(IconAtlas.record),
                      SizedBox(width: 8),
                      Text("Record new"),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
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
