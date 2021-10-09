import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';

class RecordGroup {

  Category category;
  List<Record> records = [];

  /// Returns the total price of all the records included.
  double get totalAmount {
    double amount = 0;
    for(final record in records) {
      amount += record.price;
    }
    return amount;
  }


  RecordGroup(this.category);

  /// Finds and removes the specified record.
  void removeRecord(Record record) {
    records.remove(record);
  }

  /// Adds the specified list of records.
  void addRecords(List<Record> records) {
    this.records.addAll(records);
  }
}