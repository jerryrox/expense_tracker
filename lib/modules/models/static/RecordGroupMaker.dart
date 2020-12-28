import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';

class RecordGroupMaker {
  RecordGroupMaker._();

  /// Returns the list of record groups from specified data.
  static List<RecordGroup> make(List<Category> categories, List<Item> items, List<Record> records, {bool trimEmpty = true}) {
    List<RecordGroup> groups = [];
    for (final item in items) {
      final category = categories.firstWhere((element) => element.id == item.categoryId, orElse: () => null);
      if (category == null) {
        continue;
      }
      final recordsforItem = records.where((element) => element.itemId == item.id).toList();
      if (trimEmpty && recordsforItem.isEmpty) {
        continue;
      }

      RecordGroup group = groups.firstWhere((element) => element.category == category, orElse: () => null);
      if(group == null) {
        group = RecordGroup(category);
        groups.add(group);
      }
      group.addItemRecords(item, recordsforItem);
    }
    return groups;
  }
}
