import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/budget_state.dart';
import 'package:expense_tracker/modules/dependencies/prefs.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyContainer {

  UserState userState;
  BudgetState budgetState;

  Prefs prefs;

  AppNavigation appNavigation;

  DependencyContainer() {
    userState = UserState();
    budgetState = BudgetState();

    prefs = Prefs();

    appNavigation = AppNavigation();
  }

  /// Returns the dependencies as list of providers.
  List<SingleChildWidget> getProviders() {
    return [
        Provider.value(value: userState),
        Provider.value(value: budgetState),
        Provider.value(value: prefs),
        Provider.value(value: appNavigation),
    ];
  }
}