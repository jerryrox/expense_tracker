import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/tag.dart';

/// A container class which contains association information with other class instances.
class RecordContext {

  Category category;
  List<Tag> tags;
  Record record;

  RecordContext({
    this.category,
    this.tags = const [],
    this.record,
  });
}