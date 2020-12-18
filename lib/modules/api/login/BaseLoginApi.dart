import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseLoginApi extends BaseApi<User> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;
}