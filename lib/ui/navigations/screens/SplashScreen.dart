import 'package:expense_tracker/modules/dependencies/ScreenManager.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  
  SplashScreen({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with UtilMixin {

  ScreenManager get screenManager => Provider.of<ScreenManager>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      waitSplash();
    });
  }

  /// Waits for a certain delay before navigating to the next screen.
  Future waitSplash() async {
    await Future.delayed(Duration(milliseconds: 500));

    // TODO: Check whether user is logged in.
    screenManager.toWelcome(context);
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