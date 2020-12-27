import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Category.dart';

class CreateCategoryApi extends BaseApi<Category> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String uid;
  int color;
  String name;

  CreateCategoryApi(
    this.uid,
    this.color,
    this.name,
  );

  Future<Category> request() async {
    final doc = firestore.collection(CollectionNames.getCategoryPath(uid)).doc();
    Category category = Category(
      id: doc.id,
      color: color,
      name: name,
    );

    await doc.set({
      "color": category.color,
      "name": category.name,
    });
    return category;
  }
}
