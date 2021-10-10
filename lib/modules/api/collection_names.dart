import 'package:expense_tracker/modules/models/static/path_utils.dart';

class CollectionNames {

  static const String users = "users";
  static const String categories = "categories";
  static const String records = "records";
  static const String specialBudgets = "specialBudgets";

  CollectionNames._();

  /// Returns the path of a collection or document for a user.
  static String getUserPath({String uid}) {
    return PathUtils.combineSegments([users, uid]);
  }

  /// Returns the path of a collection or document for a user's category.
  static String getCategoryPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), categories, id], leadSlash: false);
  }

  /// Returns the path of a collection or document for a user's record.
  static String getRecordPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), records, id], leadSlash: false);
  }

  /// Returns the path of a collection or document for a user's special budget.
  static String getSpecialBudgetPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), specialBudgets, id], leadSlash: false);
  }
}