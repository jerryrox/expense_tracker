import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/ui/components/primitives/CategoryCell.dart';
import 'package:flutter/material.dart';

class CategoryListDisplay extends StatelessWidget {
  final List<RecordGroup> recordGroups;
  final Function(RecordGroup) onClick;

  CategoryListDisplay({
    Key key,
    this.recordGroups,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: recordGroups
          .map((e) => CategoryCell(
                category: e.category,
                onClick: () => _onListItemButton(e),
              ))
          .toList(),
    );
  }

  /// Event called when the list item of specified record group was clicked.
  void _onListItemButton(RecordGroup recordGroup) {
    if (onClick != null) {
      onClick(recordGroup);
    }
  }
}
