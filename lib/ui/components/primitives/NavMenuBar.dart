import 'package:expense_tracker/modules/dependencies/ScreenManager.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
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
  ScreenManager get screenManager => Provider.of<ScreenManager>(context, listen: false);

  /// Navigates to the screen of specified index.
  void navigateToScreen(int index) {
    switch (NavMenuScreenType.values[index]) {
      case NavMenuScreenType.home:
        screenManager.toHome(context);
        break;
      case NavMenuScreenType.detail:
        // TODO:
        break;
      case NavMenuScreenType.statistics:
        // TODO:
        break;
      case NavMenuScreenType.settings:
        // TODO:
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
          icon: Icon(IconAtlas.detail),
          label: "Detail",
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
