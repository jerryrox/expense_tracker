import 'package:expense_tracker/modules/api/login/BaseLoginApi.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoLoginApi extends BaseLoginApi {

  @override
  Future<User> request() {
    return Future.sync(() => FirebaseAuth.instance.currentUser);
  }
}