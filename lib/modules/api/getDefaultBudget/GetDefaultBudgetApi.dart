import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';
import 'package:expense_tracker/modules/models/static/DynamicUtils.dart';

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