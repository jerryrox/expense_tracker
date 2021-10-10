import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';

class CreateUserDataApi extends BaseFirestoreApi {
  String uid;

  CreateUserDataApi(this.uid);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    final result = await doc.get();
    if (!result.exists) {
      await doc.set({
        "createdAt": Timestamp.fromDate(DateTime.now().toUtc()),
      });
    }
  }
}
