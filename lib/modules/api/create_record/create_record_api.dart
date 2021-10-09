import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/base_firestore_api.dart';
import 'package:expense_tracker/modules/api/collection_names.dart';
import 'package:expense_tracker/modules/models/record.dart';

class CreateRecordApi extends BaseFirestoreApi<Record> {

  String uid;
  String categoryId;
  double price;
  List<String> tagIds;

  CreateRecordApi(this.uid, this.categoryId, this.price, this.tagIds);

  Future<Record> request() async {
    final doc = firestore.collection(CollectionNames.getRecordPath(uid)).doc();
    Record record = Record(
      id: doc.id,
      date: DateTime.now().toUtc(),
      categoryId: categoryId,
      price: price,
      tagIds: [...tagIds],
    );

    await doc.set({
      "date": Timestamp.fromDate(record.date),
      "categoryId": categoryId,
      "price": price,
      "tagIds": tagIds,
    });
    return record;
  }
}