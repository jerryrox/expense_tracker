import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';

/// A container class which contains association information with other class instances.
class RecordContext {

  Category category;
  Record record;

  RecordContext({
    this.category,
    this.record,
  });
}