import 'package:expense_tracker/modules/dependencies/ScreenManager.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class DependencyContainer {

  UserState userState;

  ScreenManager screenManager;

  DependencyContainer() {
    userState = UserState();

    screenManager = ScreenManager();
  }

  /// Returns the dependencies as list of providers.
  List<SingleChildWidget> getProviders() {
    return [
        Provider.value(value: userState),
        Provider.value(value: screenManager),
    ];
  }
}