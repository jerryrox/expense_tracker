import 'package:expense_tracker/modules/models/Category.dart';
import 'package:expense_tracker/modules/models/Item.dart';
import 'package:expense_tracker/modules/models/RecordGroup.dart';
import 'package:expense_tracker/modules/models/Tag.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordCategoryPage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordGroupDetailPage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordItemPage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordPricePage.dart';
import 'package:expense_tracker/ui/navigations/pages/RecordTagPage.dart';
import 'package:expense_tracker/ui/navigations/pages/SpecialBudgetsPage.dart';
import 'package:expense_tracker/ui/navigations/screens/BudgetScreen.dart';
import 'package:expense_tracker/ui/navigations/screens/HomeScreen.dart';
import 'package:expense_tracker/ui/navigations/screens/SettingsScreen.dart';
import 'package:expense_tracker/ui/navigations/screens/WelcomeScreen.dart';
import 'package:flutter/material.dart';

/// Class which handles navigation of routes.
class AppNavigation {
  /// Shows the welcome screen.
  toWelcomeScreen(BuildContext context) {
    return _navScreenGeneric(context, (context) => WelcomeScreen());
  }

  /// Shows the home screen.
  toHomeScreen(BuildContext context) {
    return _navScreenGeneric(context, (context) => HomeScreen());
  }

  /// Shows the budget screen.
  toBudgetScreen(BuildContext context) {
    return _navScreenGeneric(context, (context) => BudgetScreen());
  }

  /// Shows the settings screen.
  toSettingsScreen(BuildContext context) {
    return _navScreenGeneric(context, (context) => SettingsScreen());
  }

  /// Shows the recording process's category selection page.
  toRecordCategoryPage(BuildContext context) {
    return _navPageGeneric(context, (context) => RecordCategoryPage());
  }

  /// Shows the recording process's item selection page.
  toRecordItemPage(BuildContext context, Category category) {
    return _navPageGeneric(context, (context) => RecordItemPage(category: category));
  }

  /// Shows the recording process's tag selection page.
  toRecordTagPage(BuildContext context, Category category, Item item) {
    return _navPageGeneric(context, (context) => RecordTagPage(category: category, item: item));
  }

  /// Shows the recording process's price submission page.
  toRecordPricePage(BuildContext context, Item item, List<Tag> tags) {
    return _navPageGeneric(context, (context) => RecordPricePage(item: item, tags: tags));
  }

  /// Shows the detail page for the specified record group.
  toRecordGroupDetailPage(BuildContext context, RecordGroup recordGroup) {
    return _navPageGeneric(context, (context) => RecordGroupDetailPage(recordGroup: recordGroup));
  }

  /// Shows the special budgets page.
  toSpecialBudgetsPage(BuildContext context) {
    return _navPageGeneric(context, (context) => SpecialBudgetsPage());
  }

  /// Shows the next screen with generic behavior using the specified builder.
  _navScreenGeneric(BuildContext context, WidgetBuilder builder) {
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: builder),
      (route) => false,
    );
  }

  /// Shows the next page with generic behavior using the specified builder.
  _navPageGeneric(BuildContext context, WidgetBuilder builder) {
    return Navigator.of(context).push(
      MaterialPageRoute(builder: builder),
    );
  }
}
