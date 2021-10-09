import 'package:expense_tracker/modules/api/login/base_login_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnonymousLoginApi extends BaseLoginApi {

  @override
  Future<User> request() async {
    return (await auth.signInAnonymously()).user;
  }
}