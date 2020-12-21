import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';

class RecordGroup {

  Category category;
  Item item;
  List<Record> records;

  /// Returns whether the records have been grouped with the same category.
  bool get isCategoryGroup => category != null;

  /// Returns whether the records have been grouped with the same item.
  bool get isItemGroup => item != null;

  /// Returns the total price of all the records included.
  double get totalAmount {
    double amount;
    for(final record in records) {
      amount += record.price;
    }
    return amount;
  }

  RecordGroup({
    this.category,
    this.records,
  });
}