import 'package:expense_tracker/modules/api/create_user_data/create_user_data_api.dart';
import 'package:expense_tracker/modules/api/login/anonymous_login_api.dart';
import 'package:expense_tracker/modules/api/login/base_login_api.dart';
import 'package:expense_tracker/modules/api/login/google_login_api.dart';
import 'package:expense_tracker/modules/dependencies/app_navigation.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/dialog_mixin.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/themes/icon_atlas.dart';
import 'package:expense_tracker/ui/components/primitives/button_with_constraint.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/rounded_button.dart';
import 'package:expense_tracker/ui/navigations/popups/selection_dialog_popup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SnackbarMixin, LoaderMixin, DialogMixin {
  UserState get userState => Provider.of<UserState>(context, listen: false);
  AppNavigation get appNavigation => Provider.of<AppNavigation>(context, listen: false);

  /// Starts logging in with Google.
  void loginGoogle() {
    _handleLogin(GoogleLoginApi());
  }

  /// Starts logging in anonymously.
  Future loginAnonymous() async {
    final confirmLabel = "Confirm";
    final selection = await showDialogDefault<String>(
        context,
        SelectionDialogPopup(
          title: "Anonymous login",
          message: "By using this app anonymously, your data will not be retrievable once you change your device or reinstall the app. Are you sure you want to continue anonymously?",
          selections: [
            confirmLabel,
            "Cancel"
          ],
        ));
    if (selection != confirmLabel) {
      return;
    }

    await _handleLogin(AnonymousLoginApi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        IconAtlas.app,
                        size: 48,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Expense Tracker",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "Record, organize, and view your expenses.",
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Save money!",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                ButtonWidthConstraint(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      RoundedButton(
                        child: Text("Sign in with Google"),
                        isFullWidth: true,
                        onClick: _onGoogleButton,
                      ),
                      SizedBox(height: 10),
                      RoundedButton(
                        child: Text("Start anonymously"),
                        isFullWidth: true,
                        isOutlined: true,
                        onClick: _onAnonymousButton,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Handles shared process for logging in.
  Future _handleLogin(BaseLoginApi loginApi) async {
    final loader = showLoader(context);

    try {
      final user = await loginApi.request();
      if (user == null) {
        throw "Failed retrieving user data.";
      }

      await CreateUserDataApi(user.uid).request();

      userState.user = user;
      appNavigation.toHomeScreen(context);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Event called when the Google sign in was clicked.
  void _onGoogleButton() {
    loginGoogle();
  }

  /// Event called when the anonymous sign in was clicked.
  void _onAnonymousButton() {
    loginAnonymous();
  }
}
