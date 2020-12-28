import 'package:expense_tracker/modules/api/logout/LogoutApi.dart';
import 'package:expense_tracker/modules/dependencies/AppNavigation.dart';
import 'package:expense_tracker/modules/dependencies/states/UserState.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/NavMenuBar.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with SnackbarMixin {
  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  /// Returns the current user instance.
  User get user => userState.user.value;

  /// Logs out the current user.
  Future logOut() async {
    try {
      final api = LogoutApi();
      await api.request();

      userState.user.value = null;
      appNavigation.toWelcomeScreen(context);
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavMenuBar(
        curScreenType: NavMenuScreenType.settings,
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleText("Settings"),
                Text("Signed in as ${userState.getUserIdentity()}"),
                SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    children: [
                      ListTile(
                        leading: Icon(IconAtlas.logout),
                        title: Text("Log out"),
                        onTap: _onLogoutButton,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Event called when the logout button was clicked.
  void _onLogoutButton() {
    logOut();
  }
}
