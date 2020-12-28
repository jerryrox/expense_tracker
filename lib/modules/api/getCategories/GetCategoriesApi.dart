import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Category.dart';

class GetCategoriesApi extends BaseApi<List<Category>> {

  final String uid;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  GetCategoriesApi(this.uid);

  Future<List<Category>> request() async {
    final result = await firestore.collection(CollectionNames.getCategoryPath(uid)).get();
    return result.docs.map((e) {
      final data = e.data();
      return Category(
        id: e.id,
        color: data["color"] as int,
        name: data["name"] as String,
      );
    }).toList();
  }
}