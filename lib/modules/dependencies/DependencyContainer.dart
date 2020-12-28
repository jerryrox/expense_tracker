import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/BudgetState.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyContainer {

  UserState userState;
  BudgetState budgetState;

  AppNavigation appNavigation;

  DependencyContainer() {
    userState = UserState();
    budgetState = BudgetState();

    appNavigation = AppNavigation();
  }

  /// Returns the dependencies as list of providers.
  List<SingleChildWidget> getProviders() {
    return [
        Provider.value(value: userState),
        Provider.value(value: budgetState),
        Provider.value(value: appNavigation),
    ];
  }
}