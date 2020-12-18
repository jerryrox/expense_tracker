import 'package:expense_tracker/modules/api/login/AnonymousLoginApi.dart';
import 'package:expense_tracker/modules/api/login/BaseLoginApi.dart';
import 'package:expense_tracker/modules/tasks/BaseTask.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Task which handles login process for a specific login method type.
class LoginTask extends BaseTask<User> {

  BaseLoginApi _loginApi;

  LoginTask.anonymous() {
    _loginApi = AnonymousLoginApi();
  }

  Future<User> run() async {
    final user = await _loginApi.request();
    return user;
  }
}