import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';

class DeleteSpecialBudgetApi extends BaseFirestoreApi {

  String uid;
  String specialBudgetId;

  DeleteSpecialBudgetApi(this.uid, this.specialBudgetId);

  Future request() async {
    final doc = firestore.doc(CollectionNames.getSpecialBudgetPath(uid, id: specialBudgetId));
    await doc.delete();
  }
}