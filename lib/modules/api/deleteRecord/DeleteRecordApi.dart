import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';

class DeleteRecordApi extends BaseApi {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String uid;
  String recordId;

  DeleteRecordApi(this.uid, this.recordId);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getRecordPath(uid, id: recordId));
    await doc.delete();
  }
}