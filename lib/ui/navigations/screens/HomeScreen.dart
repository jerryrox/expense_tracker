import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonGroup.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
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
    // TODO:
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FilledBox(
        child: ContentPadding(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ConstrainedBox(
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
              SizedBox(height: 20),
            ],
          ),
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
}
