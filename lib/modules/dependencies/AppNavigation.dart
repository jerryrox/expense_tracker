import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordCategoryPage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordItemPage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordPricePage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordTagPage.dart';
import 'package:expense_tracker/ui/navigations/screens/HomeScreen.dart';
import 'package:expense_tracker/ui/navigations/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

/// Class which handles navigation of routes.
class AppNavigation {
  /// Shows the welcome screen.
  toWelcomeScreen(BuildContext context) {
    _navScreenGeneric(context, (context) => WelcomeScreen());
  }

  /// Shows the home screen.
  toHomeScreen(BuildContext context) {
    _navScreenGeneric(context, (context) => HomeScreen());
  }

  /// Shows the detail screen.
  toDetailScreen(BuildContext context) {
    // TODO:
    // _showGeneric(context, (context) => HomeScreen());
  }

  /// Shows the recording process's category selection page.
  toRecordCategoryPage(BuildContext context) {
    _navPageGeneric(context, (context) => RecordCategoryPage());
  }

  /// Shows the recording process's item selection page.
  toRecordItemPage(BuildContext context, Category category) {
    _navPageGeneric(context, (context) => RecordItemPage(category: category));
  }

  /// Shows the recording process's tag selection page.
  toRecordTagPage(BuildContext context, Category category, Item item) {
    _navPageGeneric(context, (context) => RecordTagPage(category: category, item: item));
  }

  /// Shows the recording process's price submission page.
  toRecordPricePage(BuildContext context, Item item, List<Tag> tags) {
    _navPageGeneric(context, (context) => RecordPricePage(item: item, tags: tags));
  }

  /// Shows the next screen with generic behavior using the specified builder.
  _navScreenGeneric(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: builder),
      (route) => false,
    );
  }

  /// Shows the next page with generic behavior using the specified builder.
  _navPageGeneric(BuildContext context, WidgetBuilder builder) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: builder),
    );
  }
}
