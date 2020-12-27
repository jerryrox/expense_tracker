import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';

class RecordGroup {

  Category category;
  Item item;
  List<Record> records = [];

  /// Returns whether there are any records in this group.
  bool get hasRecords => records.isNotEmpty;

  /// Returns the total price of all the records included.
  double get totalAmount {
    double amount = 0;
    for(final record in records) {
      amount += record.price;
    }
    return amount;
  }


  RecordGroup(
    this.category,
    this.item,
    this.records,
  );
}