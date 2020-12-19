import 'package:expense_tracker/modules/api/login/AnonymousLoginApi.dart';
import 'package:expense_tracker/modules/api/login/AutoLoginApi.dart';
import 'package:expense_tracker/modules/api/login/BaseLoginApi.dart';
import 'package:expense_tracker/modules/tasks/BaseTask.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Task which handles login process for a specific login method type.
class LoginTask extends BaseTask<User> {

  BaseLoginApi _loginApi;

  /// Creates a new task for auto logging in.
  LoginTask.auto() {
    _loginApi = AutoLoginApi();
  }
  
  /// Creates a new task for logging in anonymously.
  LoginTask.anonymous() {
    _loginApi = AnonymousLoginApi();
  }

  Future<User> run() async {
    final user = await _loginApi.request();
    return user;
  }
}