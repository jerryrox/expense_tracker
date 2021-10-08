import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/BaseFirestoreApi.dart';
import 'package:expense_tracker/modules/api/CollectionNames.dart';
import 'package:expense_tracker/modules/models/Record.dart';
import 'package:expense_tracker/modules/models/static/DynamicUtils.dart';

class GetRecordsApi extends BaseFirestoreApi<List<Record>> {

  String uid;
  String categoryId;
  DateTime before;
  DateTime after;

  GetRecordsApi(this.uid);

  /// Applies a filter to retrieve results matching the specified category id.
  GetRecordsApi forCategory(String categoryId) {
    this.categoryId = categoryId;
    return this;
  }

  /// Applies a filter to retrieve results before the specified date.
  GetRecordsApi beforeDate(DateTime date) {
    before = date;
    return this;
  }

  /// Applies a filter to retrieve results after the specified date.
  GetRecordsApi afterDate(DateTime date) {
    after = date;
    return this;
  }

  Future<List<Record>> request() async {
    var query = firestore.collection(CollectionNames.getRecordPath(uid));
    if(categoryId != null) {
      query = query.where("categoryId", isEqualTo: categoryId);
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
        categoryId: data["categoryId"] as String,
        price: DynamicUtils.getDouble(data["price"]),
        tagIds: List.from(data["tagIds"] as Iterable<dynamic>),
      );
    }).toList();
  }
}