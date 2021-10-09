import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/record_group.dart';

class RecordGroupMaker {
  RecordGroupMaker._();

  /// Returns the list of record groups from specified data.
  static List<RecordGroup> make(List<Category> categories, List<Record> records, {bool trimEmpty = true}) {
    List<RecordGroup> groups = [];
    for(final category in categories) {
      final recordsforCategory = records.where((element) => element.categoryId == category.id).toList();
      if (trimEmpty && recordsforCategory.isEmpty) {
        continue;
      }

      RecordGroup group = groups.firstWhere((element) => element.category == category, orElse: () => null);
      if(group == null) {
        group = RecordGroup(category);
        groups.add(group);
      }
      group.addRecords(recordsforCategory);
    }
    return groups;
  }
}
