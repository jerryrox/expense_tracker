import 'package:expense_tracker/modules/api/deleteSpecialBudget/DeleteSpecialBudgetApi.dart';
import 'package:expense_tracker/modules/dependencies/BudgetState.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/DialogMixin.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';
import 'package:expense_tracker/ui/components/primitives/BottomContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/ButtonWidthConstraint.dart';
import 'package:expense_tracker/ui/components/primitives/ContentPadding.dart';
import 'package:expense_tracker/ui/components/primitives/FilledBox.dart';
import 'package:expense_tracker/ui/components/primitives/LinedDivider.dart';
import 'package:expense_tracker/ui/components/primitives/PageTopMargin.dart';
import 'package:expense_tracker/ui/components/primitives/SectionText.dart';
import 'package:expense_tracker/ui/components/primitives/SpecialBudgetCell.dart';
import 'package:expense_tracker/ui/components/primitives/TextRoundedButton.dart';
import 'package:expense_tracker/ui/navigations/popups/SelectionDialogPopup.dart';
import 'package:expense_tracker/ui/navigations/popups/SpecialBudgetPopup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SpecialBudgetsPage extends StatefulWidget {
  SpecialBudgetsPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SpecialBudgetsPageState();
}

class _SpecialBudgetsPageState extends State<SpecialBudgetsPage> with UtilMixin, SnackbarMixin, DialogMixin, LoaderMixin {
  List<SpecialBudget> upcomingBudgets = [];

  UserState get userState => Provider.of<UserState>(context, listen: false);
  BudgetState get budgetState => Provider.of<BudgetState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadSpecialBudget();
    });
  }

  /// Loads the list of special budgets from the server.
  Future loadSpecialBudget() async {
    final loader = showLoader(context);

    try {
      final budgets = await budgetState.loadSpecialBudgets(userState.uid);
      final now = DateTime.now().toUtc();
      setState(() {
        upcomingBudgets = budgets.where((element) => element.range.max.isAfter(now)).toList();
        upcomingBudgets.sort((x, y) => x.range.min.compareTo(y.range.min));
      });
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Performs action based on the user's selection.
  Future performBudgetAction(SpecialBudget budget) async {
    try {
      final deleteAction = "Delete";
      final selection = await showDialogDefault<String>(
          context,
          SelectionDialogPopup(
            message: "Choose an action for this budget.",
            selections: [
              deleteAction,
              "Cancel"
            ],
          ));

      if (selection == deleteAction) {
        _deleteBudget(budget);
      }
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Starts a new process for special budget creation for user.
  Future createNewBudget() async {
    try {
      final newBudget = await showDialogDefault<SpecialBudget>(context, SpecialBudgetPopup());
      if(newBudget != null) {
        loadSpecialBudget();
      }
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Special budgets"),
      ),
      body: SafeArea(
        child: FilledBox(
          child: ContentPadding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                PageTopMargin(),
                SectionText(
                  "Upcoming special budgets",
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      return SpecialBudgetCell(specialBudget: upcomingBudgets[index], onClick: () => _onBudgetCellButton(upcomingBudgets[index]));
                    },
                    separatorBuilder: (context, index) => LinedDivider(),
                    itemCount: upcomingBudgets.length,
                  ),
                ),
                BottomContentPadding(
                  child: ButtonWidthConstraint(
                    child: TextRoundedButton(
                      "Add new",
                      isFullWidth: true,
                      onClick: _onNewButton,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Removes the specified special budget.
  Future _deleteBudget(SpecialBudget budget) async {
    try {
      final api = DeleteSpecialBudgetApi(userState.uid, budget.id);
      await api.request();

      loadSpecialBudget();
    } catch (e) {
      showSnackbar(context, e.toString());
    }
  }

  /// Event called when the special budget cell was clicked.
  void _onBudgetCellButton(SpecialBudget budget) {
    performBudgetAction(budget);
  }

  /// Event called when the new budget button was clicked.
  void _onNewButton() {
    createNewBudget();
  }
}
