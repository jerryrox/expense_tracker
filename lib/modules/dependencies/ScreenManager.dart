import 'package:expense_tracker/ui/navigations/screens/HomeScreen.dart';
import 'package:expense_tracker/ui/navigations/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

/// Class which handles navigation of screens.
class ScreenManager {

  /// Shows the welcome screen.
  toWelcome(BuildContext context) {
    _showGeneric(context, (context) => WelcomeScreen());
  }

  /// Shows the home screen.
  toHome(BuildContext context) {
    _showGeneric(context, (context) => HomeScreen());
  }

  /// Shows the detail screen.
  toDetail(BuildContext context) {
    // TODO:
    // _showGeneric(context, (context) => HomeScreen());
  }

  /// Shows the next screen with generic behavior using the specified builder.
  _showGeneric(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: builder),
      (route) => false,
    );
  }
}