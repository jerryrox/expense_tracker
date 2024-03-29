import 'package:expense_tracker/modules/api/login/auto_login_api.dart';
import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/themes/icon_atlas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  
  SplashScreen({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with UtilMixin {

  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      performLoading();
    });
  }

  /// Waits for a certain delay before navigating to the next screen.
  Future performLoading() async {
    await Future.delayed(Duration(milliseconds: 250));

    // Check login state
    bool didLogin = await autoLogin();

    // Navigate to next screen.
    if(didLogin) {
      appNavigation.toHomeScreen(context);
    }
    else {
      appNavigation.toWelcomeScreen(context);
    }
  }

  /// Attempts to auto login and returns whether it was successful.
  Future<bool> autoLogin() async {
    try {
      final user = await AutoLoginApi().request();

      userState.user = user;
      return user != null;
    }
    catch(e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                IconAtlas.app,
                size: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}