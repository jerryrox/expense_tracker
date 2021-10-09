import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/ui/components/primitives/color_button.dart';
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
    return ListTile(
      onTap: onClick,
      leading: ColorButton(
        color: Color(category.color),
        size: 24,
      ),
      title: Text(category.name ?? ""),
    );
  }
}
