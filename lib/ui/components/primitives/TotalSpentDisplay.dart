import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:flutter/material.dart';

class TotalSpentDisplay extends StatelessWidget {
  final DateRangeType dateRangeType;
  final double amount;

  TotalSpentDisplay({
    Key key,
    this.dateRangeType,
    this.amount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          _getTitle(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        SizedBox(height: 5),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// Returns the appropriate title string for the current date range type.
  String _getTitle() {
    switch (dateRangeType) {
      case DateRangeType.day:
        return "Total spent today";
      case DateRangeType.week:
        return "Total spent this week";
      case DateRangeType.month:
        return "Total spent this month";
      case DateRangeType.year:
        return "Total spent this year";
    }
    return "Total spent";
  }
}
