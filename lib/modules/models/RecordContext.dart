import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/Tag.dart';

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