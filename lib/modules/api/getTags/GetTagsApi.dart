import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Tag.dart';

class GetTagsApi extends BaseApi<List<Tag>> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String uid;
  String categoryId;

  GetTagsApi(this.uid);

  /// Applies a filter to retrieve results matching the specified category id.
  GetTagsApi forCategory(String categoryId) {
    this.categoryId = categoryId;
    return this;
  }

  Future<List<Tag>> request() async {
    Future<QuerySnapshot> query;
    if(categoryId == null) {
      query = firestore.collection(CollectionNames.getTagPath(uid)).get();
    }
    else {
      query = firestore.collection(CollectionNames.getTagPath(uid))
        .where("categoryId", isEqualTo: categoryId)
        .get();
    }

    final result = await query;
    return result.docs.map((e) {
      final data = e.data();
      return Tag(
        id: e.id,
        categoryId: data["categoryId"] as String,
        name: data["name"] as String
      );
    }).toList();
  }
}