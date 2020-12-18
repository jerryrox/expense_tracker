import 'package:expense_tracker/modules/models/Bindable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserState {

  final Bindable<User> user = Bindable(null);
}