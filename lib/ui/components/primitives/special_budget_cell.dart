import 'package:expense_tracker/modules/models/special_budget.dart';
import 'package:expense_tracker/modules/models/static/date_formatter.dart';
import 'package:flutter/material.dart';

class SpecialBudgetCell extends StatelessWidget {
  final SpecialBudget specialBudget;
  final Function() onClick;

  SpecialBudgetCell({
    Key key,
    this.specialBudget,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      onTap: onClick,
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "\$${specialBudget.budget.toStringAsFixed(2)}",
            style: TextStyle(fontSize: 18,),
          ),
          Text(
            "(\$${specialBudget.budgetPerDay.toStringAsFixed(2)} p/d)",
            style: TextStyle(fontSize: 13, color: theme.disabledColor),
          ),
        ],
      ),
      trailing: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            "Starts ${DateFormatter.yyyymmdd(specialBudget.range.min.toLocal())}",
            style: TextStyle(
              fontSize: 13,
              color: theme.disabledColor,
            ),
          ),
          Text(
            "Ends ${DateFormatter.yyyymmdd(specialBudget.range.max.toLocal().subtract(Duration(days: 1)))}",
            style: TextStyle(
              fontSize: 13,
              color: theme.disabledColor,
            ),
          ),
        ],
      ),
    );
  }
}
