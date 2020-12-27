import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/Tag.dart';

class NewRecordData {

  Category category;
  List<Tag> tags;
  Item item;
  Record record;

  NewRecordData({
    this.category,
    this.tags = const [],
    this.item,
    this.record,
  });
}