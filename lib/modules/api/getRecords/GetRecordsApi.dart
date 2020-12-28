import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Record.dart';

class GetRecordsApi extends BaseFirestoreApi<List<Record>> {

  String uid;
  String itemId;
  DateTime before;
  DateTime after;

  GetRecordsApi(this.uid);

  /// Applies a filter to retrieve results matching the specified item id.
  GetRecordsApi forItem(String itemId) {
    this.itemId = itemId;
    return this;
  }

  /// Applies a filter to retrieve results before the specified date.
  GetRecordsApi beforeDate(DateTime date) {
    this.before = date;
    return this;
  }

  /// Applies a filter to retrieve results after the specified date.
  GetRecordsApi afterDate(DateTime date) {
    this.after = date;
    return this;
  }

  Future<List<Record>> request() async {
    Query query = firestore.collection(CollectionNames.getRecordPath(uid));
    if(itemId != null) {
      query = query.where("itemId", isEqualTo: itemId);
    }
    if(before != null) {
      query = query.where("date", isLessThanOrEqualTo: Timestamp.fromDate(before));
    }
    if(after != null) {
      query = query.where("date", isGreaterThanOrEqualTo: Timestamp.fromDate(after));
    }

    final result = await query.get();
    return result.docs.map((e) {
      final data = e.data();
      return Record(
        id: e.id,
        date: (data["date"] as Timestamp).toDate(),
        itemId: data["itemId"] as String,
        price: data["price"] as double,
        tagIds: List.from(data["tagIds"] as Iterable<dynamic>),
      );
    }).toList();
  }
}