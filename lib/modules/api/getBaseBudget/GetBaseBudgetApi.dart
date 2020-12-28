import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';

class GetBaseBudgetApi extends BaseFirestoreApi<double> {

  String uid;

  GetBaseBudgetApi(this.uid);

  Future<double> request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    final data = await doc.get();
    return (data["baseBudget"] as double) ?? 0;
  }
}