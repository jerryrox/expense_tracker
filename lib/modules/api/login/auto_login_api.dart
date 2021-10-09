import 'package:expense_tracker/modules/api/login/base_login_api.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AutoLoginApi extends BaseLoginApi {

  @override
  Future<User> request() async {
    for(int i=0; i<4; i++) {
      await Future.delayed(Duration(milliseconds: 500));
      final user = FirebaseAuth.instance.currentUser;
      if(user != null) {
        return user;
      }
    }
    return null;
  }
}