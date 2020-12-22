import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/ui/components/primitives/ColorButton.dart';
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
      children: recordGroups.map((e) => _drawListItem(context, e)).toList(),
    );
  }

  /// Returns the list item widget for the list.
  Widget _drawListItem(BuildContext context, RecordGroup recordGroup) {
    final theme = Theme.of(context);

    return Ink(
      color: theme.scaffoldBackgroundColor,
      child: InkWell(
        onTap: () => _onListItemButton(recordGroup),
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
                color: Color(recordGroup.category.color),
                size: 24,
              ),
              SizedBox(width: 8),
              Flexible(
                child: Text(
                  recordGroup.category.name,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Event called when the list item of specified record group was clicked.
  void _onListItemButton(RecordGroup recordGroup) {
    if (onClick != null) {
      onClick(recordGroup);
    }
  }
}
