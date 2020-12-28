import 'package:expense_tracker/modules/models/Bindable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {

  final Bindable<User> user = Bindable(null);


  /// Returns the uid of the current user.
  String get uid => user.value.uid;


  /// Returns the string value which describes the user's identity.
  String getUserIdentity() {
    final user = this.user.value;
    if(user == null) {
      return "Offline User";
    }
    if(user.isAnonymous) {
      return "Anonymous User";
    }
    if(user.email != null && user.email.isNotEmpty) {
      return user.email;
    }
    if(user.displayName != null && user.displayName.isNotEmpty) {
      return user.displayName;
    }
    return "Online User";
  }
}