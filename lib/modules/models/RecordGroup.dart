import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';

class RecordGroup {

  Category category;
  Map<Item, List<Record>> itemDictionary = {};

  /// Returns the total price of all the records included.
  double get totalAmount {
    double amount = 0;
    for(final records in itemDictionary.values) {
      for(final record in records) {
        amount += record.price;
      }
    }
    return amount;
  }


  RecordGroup(this.category);

  /// Adds a new item and records list to this group.
  void addItemRecords(Item item, List<Record> records) {
    if(records.isEmpty) {
      return;
    }
    itemDictionary[item] = records;
  }
}