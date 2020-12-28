import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Tag.dart';

class CreateTagApi extends BaseApi<Tag> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

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