import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Api which represents any type of login method.
/// Responds with the Firebase [User] instance if successful.
/// Responds with [null] if not logged in.
abstract class BaseLoginApi extends BaseApi<User> {
  
  final FirebaseAuth auth = FirebaseAuth.instance;
}