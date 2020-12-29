import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';

class GetDefaultBudgetApi extends BaseFirestoreApi<DefaultBudget> {

  String uid;

  GetDefaultBudgetApi(this.uid);

  Future<DefaultBudget> request() async {
    final doc = firestore.doc(CollectionNames.getUserPath(uid: uid));
    final data = await doc.get();
    if(data.exists) {
      final defaultBudget = data.data()["defaultBudget"] as double;
      return defaultBudget == null ? null : DefaultBudget(defaultBudget);
    }
    return null;
  }
}