import 'package:expense_tracker/modules/models/category.dart';
import 'package:expense_tracker/modules/models/record_group.dart';
import 'package:expense_tracker/modules/models/tag.dart';
import 'package:expense_tracker/ui/navigations/pages/record_category_page.dart';
import 'package:expense_tracker/ui/navigations/pages/record_group_detail_page.dart';
import 'package:expense_tracker/ui/navigations/pages/record_price_page.dart';
import 'package:expense_tracker/ui/navigations/pages/record_tag_page.dart';
import 'package:expense_tracker/ui/navigations/pages/special_budgets_page.dart';
import 'package:expense_tracker/ui/navigations/screens/budget_screen.dart';
import 'package:expense_tracker/ui/navigations/screens/home_screen.dart';
import 'package:expense_tracker/ui/navigations/screens/settings_screen.dart';
import 'package:expense_tracker/ui/navigations/screens/welcome_screen.dart';
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

  /// Shows the recording process's tag selection page.
  toRecordTagPage(BuildContext context, Category category) {
    return _navPageGeneric(context, (context) => RecordTagPage(category: category));
  }

  /// Shows the recording process's price submission page.
  toRecordPricePage(BuildContext context, Category category, List<Tag> tags) {
    return _navPageGeneric(context, (context) => RecordPricePage(category: category, tags: tags));
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
