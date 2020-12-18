import 'package:expense_tracker/modules/api/login/AnonymousLoginApi.dart';
import 'package:expense_tracker/modules/api/login/BaseLoginApi.dart';
import 'package:expense_tracker/modules/types/LoginMethodType.dart';

class ApiProvider {

  /// Returns a new login api.
  BaseLoginApi login(LoginMethodType type) {
    switch(type) {
      case LoginMethodType.anonymous: return AnonymousLoginApi();
    }
    return null;
  }
}