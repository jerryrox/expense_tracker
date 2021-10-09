import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';

class DeleteRecordApi extends BaseFirestoreApi {

  String uid;
  String recordId;

  DeleteRecordApi(this.uid, this.recordId);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getRecordPath(uid, id: recordId));
    await doc.delete();
  }
}