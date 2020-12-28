import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';

class UpdateBaseBudgetApi extends BaseFirestoreApi {

  String uid;
  double baseBudget;

  UpdateBaseBudgetApi(this.uid, this.baseBudget);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    await doc.update({
      "baseBudget": baseBudget,
    });
  }
}