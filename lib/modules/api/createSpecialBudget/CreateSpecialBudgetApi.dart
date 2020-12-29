import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';

class CreateSpecialBudgetApi extends BaseFirestoreApi<SpecialBudget> {
  String uid;
  DateTime start;
  DateTime end;
  double budget;

  CreateSpecialBudgetApi(
    this.uid,
    this.start,
    this.end,
    this.budget,
  );

  Future<SpecialBudget> request() async {
    final doc = firestore.collection(CollectionNames.getSpecialBudgetPath(uid)).doc();
    SpecialBudget specialBudget = SpecialBudget(
      id: doc.id,
      range: DateRange.withMinMax(start, end),
      budget: budget,
    );

    await doc.set({
      "start": Timestamp.fromDate(specialBudget.range.min),
      "end": Timestamp.fromDate(specialBudget.range.max),
      "budget": specialBudget.budget,
    });
    return specialBudget;
  }
}
