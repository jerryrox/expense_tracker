import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Item.dart';

class GetItemsApi extends BaseFirestoreApi<List<Item>> {

  String uid;
  String categoryId;

  GetItemsApi(this.uid);

  /// Applies a filter to search for results matching the specified category.
  GetItemsApi forCategory(String categoryId) {
    this.categoryId = categoryId;
    return this;
  }

  Future<List<Item>> request() async {
    Future<QuerySnapshot> query;
    if(categoryId == null) {
      query = firestore.collection(CollectionNames.getItemPath(uid)).get();
    }
    else {
      query = firestore.collection(CollectionNames.getItemPath(uid))
        .where("categoryId", isEqualTo: categoryId)
        .get();
    }

    final result = await query;
    return result.docs.map((e) {
      final data = e.data();
      return Item(
        id: e.id,
        categoryId: data["categoryId"] as String,
        name: data["name"] as String,
      );
    }).toList();
  }
}