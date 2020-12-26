import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/tasks/LoginTask.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
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
      final autoLoginTask = LoginTask.auto();
      final user = await autoLoginTask.run();

      userState.user.value = user;
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