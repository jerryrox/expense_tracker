import 'package:expense_tracker/modules/models/navigations/BaseRouteInfo.dart';
import 'package:expense_tracker/ui/navigations/screens/HomeScreen.dart';
import 'package:flutter/material.dart';

class AppRouterDelegate extends RouterDelegate<BaseRouteInfo> with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  
  GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  BaseRouteInfo _curRouteInfo;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  BaseRouteInfo get currentConfiguration {
    return _curRouteInfo;
  }


  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: HomeScreen()),
      ],
      onPopPage: (route, result) {
        if(!route.didPop(result)) {
          return false;
        }

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BaseRouteInfo configuration) async {
    this._curRouteInfo = configuration;

    // TODO: Check whether route info requires auth and if true, check if user is currently authenticated.

  }
}