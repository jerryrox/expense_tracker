import 'package:expense_tracker/modules/models/navigations/BaseRouteInfo.dart';
import 'package:expense_tracker/modules/models/navigations/HomeRouteInfo.dart';
import 'package:expense_tracker/modules/models/navigations/RouteMatchInfo.dart';
import 'package:expense_tracker/modules/models/navigations/RouteMatcher.dart';
import 'package:flutter/material.dart';

class AppRouteInfoParser extends RouteInformationParser<BaseRouteInfo> {

  RouteMatcher _homeMatcher = RouteMatcher("/", isExact: true);

  List<RouteMatcher> _routeMatchers;

  AppRouteInfoParser() {
    _routeMatchers = [
      _homeMatcher,
    ];
  }

  @override
  Future<BaseRouteInfo> parseRouteInformation(RouteInformation routeInformation) {
    return Future.sync(() {
      for(final matcher in _routeMatchers) {
        final match = matcher.getMatch(routeInformation.location);
        if(match.isMatching) {
          return _getRouteInfo(matcher, match);
        }
      }
      return null;
    });
  }

  @override
  RouteInformation restoreRouteInformation(BaseRouteInfo info) {
    return RouteInformation(location: info.getPath());
  }

  /// Returns the route info for the specified matcher.
  BaseRouteInfo _getRouteInfo(RouteMatcher matcher, RouteMatchInfo match) {
    if(matcher == _homeMatcher) {
      return HomeRouteInfo(matcher.path, match);
    }

    // TODO: Return UnknownRouteInfo.
    return null;
  }
}