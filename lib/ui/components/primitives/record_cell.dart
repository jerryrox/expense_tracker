import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/static/date_formatter.dart';
import 'package:flutter/material.dart';

class RecordCell extends StatelessWidget {
  final Category category;
  final Record record;
  final Function() onClick;

  RecordCell({
    Key key,
    this.category,
    this.record,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    category.name,
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${record.price}",
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      DateFormatter.yyyymmddHHMM(record.date.toLocal()),
                      style: TextStyle(
                        color: theme.disabledColor,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
