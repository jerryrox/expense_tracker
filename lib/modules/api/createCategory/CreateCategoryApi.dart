import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Category.dart';

class CreateCategoryApi extends BaseFirestoreApi<Category> {
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
