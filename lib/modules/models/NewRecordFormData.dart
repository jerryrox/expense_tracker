import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Tag.dart';

class NewRecordFormData {

  Category category;
  List<Tag> tags;
  Item item;

  NewRecordFormData({
    this.category,
    this.tags = const [],
    this.item,
  });
}