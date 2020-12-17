import 'package:expense_tracker/modules/models/navigations/BaseRouteInfo.dart';

/// Class which contains the information of route matcher evaluation result.
class RouteMatchInfo {

  final bool isMatching;
  final Map<String, String> params;

  RouteMatchInfo.match(this.params) :
    this.isMatching = true;

  RouteMatchInfo.noMatch() :
    this.isMatching = false,
    this.params = {};
}