import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/themes/icon_atlas.dart';
import 'package:expense_tracker/modules/types/nav_menu_screen_type.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NavMenuBar extends StatefulWidget {
  final NavMenuScreenType curScreenType;

  NavMenuBar({
    Key key,
    this.curScreenType,
  }) : super(key: key);

  @override
  _NavMenuBarState createState() => _NavMenuBarState();
}

class _NavMenuBarState extends State<NavMenuBar> {
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  /// Navigates to the screen of specified index.
  void navigateToScreen(int index) {
    final selectedType = NavMenuScreenType.values[index];
    if (selectedType == widget.curScreenType) {
      return;
    }
    switch (selectedType) {
      case NavMenuScreenType.home:
        appNavigation.toHomeScreen(context);
        break;
      case NavMenuScreenType.budget:
        appNavigation.toBudgetScreen(context);
        break;
      case NavMenuScreenType.statistics:
        // TODO:
        break;
      case NavMenuScreenType.settings:
        appNavigation.toSettingsScreen(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      onTap: _onNavButton,
      currentIndex: NavMenuScreenType.values.indexOf(widget.curScreenType),
      selectedItemColor: theme.primaryColor,
      unselectedItemColor: theme.disabledColor,
      items: [
        BottomNavigationBarItem(
          icon: Icon(IconAtlas.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconAtlas.budget),
          label: "Budget",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconAtlas.statistics),
          label: "Stats",
        ),
        BottomNavigationBarItem(
          icon: Icon(IconAtlas.settings),
          label: "Settings",
        ),
      ],
    );
  }

  /// Event called when the nav item of specified index was clicked.
  void _onNavButton(int index) {
    navigateToScreen(index);
  }
}
