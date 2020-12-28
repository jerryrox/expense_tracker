import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/modules/models/static/DateFormatter.dart';
import 'package:expense_tracker/ui/components/primitives/TagCell.dart';
import 'package:flutter/material.dart';

class RecordCell extends StatelessWidget {
  final Item item;
  final Record record;
  final List<Tag> tags;
  final Function() onClick;

  RecordCell({
    Key key,
    this.item,
    this.record,
    this.tags,
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
                    item.name,
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
            Wrap(
              children: tags.map((e) => TagCell(tag: e)).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
