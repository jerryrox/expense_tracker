import 'package:expense_tracker/modules/models/tag.dart';
import 'package:flutter/material.dart';

class TagCell extends StatelessWidget {
  final Tag tag;
  final bool isSelected;
  final Function() onClick;

  TagCell({
    Key key,
    this.tag,
    this.isSelected = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tint = isSelected ? theme.primaryColor : theme.disabledColor;

    return InkWell(
      borderRadius: BorderRadius.circular(100),
      onTap: onClick,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: tint,
            width: 2,
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              tag.name ?? "",
              style: TextStyle(
                color: tint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
