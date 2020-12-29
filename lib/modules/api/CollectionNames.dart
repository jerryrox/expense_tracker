import 'package:expense_tracker/modules/models/static/PathUtils.dart';

class CollectionNames {

  static final String users = "users";
  static final String categories = "categories";
  static final String tags = "tags";
  static final String items = "items";
  static final String records = "records";
  static final String specialBudgets = "specialBudgets";

  CollectionNames._();

  /// Returns the path of a collection or document for a user.
  static String getUserPath({String uid}) {
    return PathUtils.combineSegments([users, uid]);
  }

  /// Returns the path of a collection or document for a user's category.
  static String getCategoryPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), categories, id], leadSlash: false);
  }

  /// Returns the path of a collection or document for a user's tag.
  static String getTagPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), tags, id], leadSlash: false);
  }

  /// Returns the path of a collection or document for a user's item.
  static String getItemPath(String uid, {String id}) {
    return PathUtils.combineSegments([getUserPath(uid: uid), items, id], leadSlash: false);
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