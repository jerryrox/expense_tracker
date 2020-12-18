import 'package:expense_tracker/modules/dependencies/ScreenManager.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/tasks/LoginTask.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SnackbarMixin {
  UserState get userState => Provider.of<UserState>(context, listen: false);
  ScreenManager get screenManager => Provider.of<ScreenManager>(context, listen: false);

  /// Starts logging in anonymously.
  Future loginAnonymous() async {
    try {
      final loginTask = LoginTask.anonymous();
      final user = await loginTask.run();
      if(user == null) {
        throw "Failed to request anonymous login.";
      }

      userState.user.value = user;
      screenManager.toHome(context);
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Event called on clicking the get started button.
  void onGetStartedButton() {
    loginAnonymous();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FilledBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    IconAtlas.app,
                    size: 48,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Expense Tracker",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Record, organize, and view your expenses.",
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Save money!",
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: RoundedButton(
                  child: Text("Get started"),
                  isFullWidth: true,
                  onClick: onGetStartedButton,
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
