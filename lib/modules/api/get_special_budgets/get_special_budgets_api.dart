import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';
import 'package:expense_tracker/modules/models/date_range.dart';
import 'package:expense_tracker/modules/models/special_budget.dart';
import 'package:expense_tracker/modules/models/static/dynamic_utils.dart';

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
    Query query = firestore.collection(CollectionNames.getSpecialBudgetPath(uid));
    if(from != null) {
      query = query.where("end", isGreaterThan: Timestamp.fromDate(from));
    }
    final result = await query.get();

    List<SpecialBudget> budgets = [];
    budgets.addAll(result.docs.map((e) {
      dynamic data = e.data();
      return SpecialBudget(
        id: e.id,
        range: DateRange.withMinMax(
          (data["start"] as Timestamp).toDate(),
          (data["end"] as Timestamp).toDate(),
        ),
        budget: DynamicUtils.getDouble(data["budget"]),
      );
    }));
    return budgets;
  }
}
