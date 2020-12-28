import 'package:expense_tracker/modules/api/login/AnonymousLoginApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SnackbarMixin, LoaderMixin {
  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  /// Starts logging in anonymously.
  Future loginAnonymous() async {
    final loader = showLoader(context);
    
    try {
      final user = await AnonymousLoginApi().request();
      if (user == null) {
        throw "Failed to request anonymous login.";
      }

      userState.user.value = user;
      appNavigation.toHomeScreen(context);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FilledBox(
        child: ContentPadding(
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
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 300,
                ),
                child: RoundedButton(
                  child: Text("Get started"),
                  isFullWidth: true,
                  onClick: _onGetStartedButton,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// Event called on clicking the get started button.
  void _onGetStartedButton() {
    loginAnonymous();
  }
}
