import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';

class UpdateDefaultBudgetApi extends BaseFirestoreApi {

  String uid;
  double defaultBudget;

  UpdateDefaultBudgetApi(this.uid, this.defaultBudget);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    await doc.update({
      "defaultBudget": defaultBudget,
    });
  }
}