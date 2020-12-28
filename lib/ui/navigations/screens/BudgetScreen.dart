import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/types/NavMenuScreenType.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/NavMenuBar.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:expense_tracker/ui/components/primitives/TitleText.dart';
import 'package:flutter/material.dart';

class BudgetScreen extends StatefulWidget {
  BudgetScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> with UtilMixin, SnackbarMixin, LoaderMixin {
  /// Returns whether there is a budget set up by the user.
  bool get hasBudget => false;

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadBudget();
    });
  }

  /// Loads budget data from server.
  Future loadBudget() async {
    
  }

  /// Starts a new budget set up process for the user.
  Future setupBudget() async {
    try {
      // TODO: Show BudgetSetupPopup
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavMenuBar(
        curScreenType: NavMenuScreenType.budget,
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TitleText("Budget"),
                Expanded(
                  child: hasBudget ? _drawBudgetContent() : _drawNoBudgetContent(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Draws the content for when the user does not have a budget set up.
  Widget _drawNoBudgetContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("There is no budget set up."),
        SizedBox(height: 10),
        Text(
          "With this feature, you can easily track how much you are planning to use, have used, and can safely use.",
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        TextRoundedButton(
          "Set up budget",
          onClick: _onSetupBudgetButton,
        )
      ],
    );
  }

  /// Draws the content for when the user has a budget set up.
  Widget _drawBudgetContent() {}

  /// Event called when the budget setup button was clicked.
  void _onSetupBudgetButton() {
    setupBudget();
  }
}
