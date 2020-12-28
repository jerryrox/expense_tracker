import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LogoutApi extends BaseApi {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future request() {
    return auth.signOut();
  }
}