import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';
import 'package:expense_tracker/modules/models/default_budget.dart';

class UpdateDefaultBudgetApi extends BaseFirestoreApi<DefaultBudget> {

  String uid;
  double defaultBudget;

  UpdateDefaultBudgetApi(this.uid, this.defaultBudget);

  Future<DefaultBudget> request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    await doc.update({
      "defaultBudget": defaultBudget,
    });

    final newBudget = DefaultBudget(defaultBudget);
    return newBudget;
  }
}