import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Item.dart';

class CreateItemApi extends BaseFirestoreApi<Item> {

  String uid;
  String categoryId;
  String name;

  CreateItemApi(this.uid, this.categoryId, this.name);

  Future<Item> request() async {
    final doc = firestore.collection(CollectionNames.getItemPath(uid)).doc();
    Item item = Item(
      id: doc.id,
      categoryId: categoryId,
      name: name,
    );

    await doc.set({
      "categoryId": item.categoryId,
      "name": item.name,
    });
    return item;
  }
}