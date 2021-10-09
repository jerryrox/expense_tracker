import 'package:expense_tracker/modules/api/delete_special_budget/delete_special_budget_api.dart';
import 'package:expense_tracker/modules/dependencies/budget_state.dart';
import 'package:expense_tracker/modules/dependencies/user_state.dart';
import 'package:expense_tracker/modules/mixins/dialog_mixin.dart';
import 'package:expense_tracker/modules/mixins/loader_mixin.dart';
import 'package:expense_tracker/modules/mixins/snackbar_mixin.dart';
import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:expense_tracker/modules/models/special_budget.dart';
import 'package:expense_tracker/ui/components/primitives/bottom_content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/button_with_constraint.dart';
import 'package:expense_tracker/ui/components/primitives/content_padding.dart';
import 'package:expense_tracker/ui/components/primitives/filled_box.dart';
import 'package:expense_tracker/ui/components/primitives/lined_divider.dart';
import 'package:expense_tracker/ui/components/primitives/page_top_margin.dart';
import 'package:expense_tracker/ui/components/primitives/section_text.dart';
import 'package:expense_tracker/ui/components/primitives/special_budget_cell.dart';
import 'package:expense_tracker/ui/components/primitives/text_rounded_button.dart';
import 'package:expense_tracker/ui/navigations/popups/selection_dialog_popup.dart';
import 'package:expense_tracker/ui/navigations/popups/special_budget_popup.dart';
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
      if (newBudget != null) {
        loadSpecialBudget();
      }
    } catch (e) {
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
                      return SpecialBudgetCell(
                        specialBudget: upcomingBudgets[index],
                        onClick: () => _onBudgetCellButton(upcomingBudgets[index]),
                      );
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
