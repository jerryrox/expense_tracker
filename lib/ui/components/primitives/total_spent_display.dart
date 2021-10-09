import 'package:expense_tracker/modules/models/static/math_utils.dart';
import 'package:expense_tracker/modules/types/date_range_type.dart';
import 'package:flutter/material.dart';

class TotalSpentDisplay extends StatelessWidget {
  final DateRangeType dateRangeType;
  final double amount;
  final double budget;

  TotalSpentDisplay({
    Key key,
    this.dateRangeType,
    this.amount = 0,
    this.budget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        _drawBudgetInfo(theme),
      ],
    );
  }

  /// Draws additional widgets to display budget information.
  Widget _drawBudgetInfo(ThemeData theme) {
    if(budget == null) {
      return Container();
    }

    final isOverused = amount > budget;
    final diff = MathUtils.abs(budget - amount);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5),
        Text("Budget: \$${budget.toStringAsFixed(2)}"),
        Text(
          isOverused ? "Overused: \$${diff.toStringAsFixed(2)}" : "Remaining: \$${diff.toStringAsFixed(2)}",
          style: TextStyle(
            color: isOverused ? theme.errorColor : theme.primaryColor,
            fontSize: 14,
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
