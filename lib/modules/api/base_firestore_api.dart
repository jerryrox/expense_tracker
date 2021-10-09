import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/modules/api/base_api.dart';

abstract class BaseFirestoreApi<T> extends BaseApi<T> {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
}