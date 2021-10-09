import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';
import 'package:expense_tracker/modules/models/default_budget.dart';
import 'package:expense_tracker/modules/models/static/dynamic_utils.dart';

class GetDefaultBudgetApi extends BaseFirestoreApi<DefaultBudget> {

  String uid;

  GetDefaultBudgetApi(this.uid);

  Future<DefaultBudget> request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    final data = await doc.get();
    if(data.exists) {
      final defaultBudget = DynamicUtils.getDouble(data.data()["defaultBudget"]);
      return defaultBudget == null ? null : DefaultBudget(defaultBudget);
    }
    return null;
  }
}