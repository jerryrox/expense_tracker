import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
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
      start: start,
      end: end,
      budget: budget,
    );

    await doc.set({
      "start": Timestamp.fromDate(specialBudget.start),
      "end": Timestamp.fromDate(specialBudget.end),
      "budget": specialBudget.budget,
    });
    return specialBudget;
  }
}
