import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Record.dart';

class CreateRecordApi extends BaseApi<Record> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  String uid;
  String itemId;
  double price;
  List<String> tagIds;

  CreateRecordApi(this.uid, this.itemId, this.price, this.tagIds);

  Future<Record> request() async {
    final doc = firestore.collection(CollectionNames.getRecordPath(uid)).doc();
    Record record = Record(
      id: doc.id,
      date: DateTime.now().toUtc(),
      itemId: itemId,
      price: price,
      tagIds: [...tagIds],
    );

    await doc.set({
      "date": Timestamp.fromDate(record.date),
      "itemId": itemId,
      "price": price,
      "tagIds": tagIds,
    });
    return record;
  }
}