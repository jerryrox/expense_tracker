import 'package:expense_tracker/modules/models/Item.dart';
import 'package:flutter/material.dart';

class ItemCell extends StatelessWidget {
  final Item item;
  final Function() onClick;

  ItemCell({
    Key key,
    this.item,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(item.name ?? ""),
      ),
    );
  }
}
