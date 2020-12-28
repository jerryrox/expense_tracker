import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';

class GetSpecialBudgetsApi extends BaseFirestoreApi<List<SpecialBudget>> {
  String uid;
  DateTime from;

  GetSpecialBudgetsApi(this.uid);

  /// Applies filter to retrieve results from specified date.
  GetSpecialBudgetsApi fromDate(DateTime from) {
    this.from = from;
    return this;
  }

  /// Applies filter to retrieve results from the start of this year.
  GetSpecialBudgetsApi fromThisYear() {
    return fromDate(DateTime.utc(DateTime.now().toUtc().year));
  }

  Future<List<SpecialBudget>> request() async {
    final collection = firestore.collection(CollectionNames.getSpecialBudgetPath(uid));
    final result = await collection.get();

    List<SpecialBudget> budgets = [];
    budgets.addAll(result.docs.map((e) {
      final data = e.data();
      return SpecialBudget(
        id: e.id,
        start: (data["start"] as Timestamp).toDate(),
        end: (data["end"] as Timestamp).toDate(),
        budget: data["budget"] as double,
      );
    }));
    return budgets;
  }
}
