import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyContainer {

  UserState userState;

  AppNavigation appNavigation;

  DependencyContainer() {
    userState = UserState();

    appNavigation = AppNavigation();
  }

  /// Returns the dependencies as list of providers.
  List<SingleChildWidget> getProviders() {
    return [
        Provider.value(value: userState),
        Provider.value(value: appNavigation),
    ];
  }
}