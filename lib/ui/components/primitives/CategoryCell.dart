import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/ui/components/primitives/ColorButton.dart';
import 'package:flutter/material.dart';

class CategoryCell extends StatelessWidget {
  final Category category;
  final Function() onClick;

  CategoryCell({
    Key key,
    this.category,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Ink(
      color: theme.scaffoldBackgroundColor,
      child: InkWell(
        onTap: onClick,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          height: 40,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: theme.dividerColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ColorButton(
                color: Color(category.color),
                size: 24,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  category.name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
