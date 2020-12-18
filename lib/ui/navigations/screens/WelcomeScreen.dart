import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  /// Event called on clicking the get started button.
  void onGetStartedButton() {
    // TODO: Login
    // TODO: Navigate to HomeScreen.
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
