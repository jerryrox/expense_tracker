import 'package:expense_tracker/modules/models/navigations/NavigationPath.dart';
import 'package:expense_tracker/modules/models/navigations/RouteMatchInfo.dart';

/// Class which contains the information about a navigation route.
abstract class BaseRouteInfo {

  NavigationPath _navigationPath;
  RouteMatchInfo _matchInfo;


  /// Returns the path info of the route.
  NavigationPath get navigationPath => _navigationPath;

  /// Returns whether the route requires an authentication state.
  bool get requiresAuth => false;


  BaseRouteInfo(NavigationPath path, RouteMatchInfo matchInfo) {
    this._navigationPath = path;
    this._matchInfo = matchInfo;
  }

  /// Returns the actual path that led to this route.
  String getPath() {
    return _navigationPath.getPathWithParams(_matchInfo.params);
  }

  /// Returns the parameter value for the specified path param key.
  String getMatchParam(String key) {
    return _matchInfo.params[key];
  }
}