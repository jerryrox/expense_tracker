import 'package:expense_tracker/modules/api/BaseApi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleLoginApi extends BaseApi<User> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> request() async {
    final googleUser = await GoogleSignIn().signIn();
    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await auth.signInWithCredential(credential);
    return userCredential.user;
  }
}