import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';
import 'package:expense_tracker/modules/models/tag.dart';

class CreateTagApi extends BaseFirestoreApi<Tag> {

  String uid;
  String categoryId;
  String name;

  CreateTagApi(this.uid, this.categoryId, this.name);

  Future<Tag> request() async {
    final doc = firestore.collection(CollectionNames.getTagPath(uid)).doc();
    Tag tag = Tag(
      id: doc.id,
      categoryId: categoryId,
      name: name,
    );

    await doc.set({
      "categoryId": tag.categoryId,
      "name": tag.name,
    });
    return tag;
  }
}