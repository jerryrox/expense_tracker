import 'package:expense_tracker/modules/api/updateDefaultBudget/UpdateDefaultBudgetApi.dart';
import 'package:expense_tracker/modules/dependencies/BudgetState.dart';
import 'package:expense_tracker/modules/dependencies/UserState.dart';
import 'package:expense_tracker/modules/mixins/LoaderMixin.dart';
import 'package:expense_tracker/modules/mixins/SnackbarMixin.dart';
import 'package:expense_tracker/modules/mixins/UtilMixin.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';
import 'package:expense_tracker/modules/models/static/InputValidator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetSetupPopup extends StatefulWidget {
  BudgetSetupPopup({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _BudgetSetupPopupState();
}

class _BudgetSetupPopupState extends State<BudgetSetupPopup> with SnackbarMixin, UtilMixin, LoaderMixin {
  DefaultBudget budget = DefaultBudget(0);
  TextEditingController inputController = TextEditingController();

  UserState get userState => Provider.of<UserState>(context, listen: false);
  BudgetState get budgetState => Provider.of<BudgetState>(context, listen: false);

  @override
  void initState() {
    super.initState();

    afterFrameRender(() {
      loadBudget();
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  /// Loads the budget data from the server.
  Future loadBudget() async {
    final loader = showLoader(context);

    try {
      budgetState.loadBudget(userState.uid);
      setState(() {
        final totalBudget = budgetState.defaultBudget.value?.totalBudget ?? 0;
        inputController.text = totalBudget.toStringAsFixed(2);
        budget.totalBudget = totalBudget;
      });
    }
    catch(e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Saves the budget information with the current state.
  Future saveBudget() async {
    final loader = showLoader(context);

    try {
      if(budget.totalBudget <= 0) {
        throw "Budget must be greater than 0.";
      }

      final api = UpdateDefaultBudgetApi(userState.uid, budget.totalBudget);
      final newBudget = await api.request();
      closePopup(newBudget);
    } catch (e) {
      showSnackbar(context, e.toString());
    }

    loader.remove();
  }

  /// Sets the budget amount.
  void setBudget(String value) {
    setState(() => budget.totalBudget = double.tryParse(value) ?? 0);
  }

  /// Closes the popup with the specified return data.
  void closePopup(DefaultBudget budget) {
    Navigator.of(context).pop(budget);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Set up budget"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "How much are you planning to use on average per week?",
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          TextField(
            controller: inputController,
            inputFormatters: [InputValidator.numberFormatter],
            onChanged: _onBudgetChanged,
          ),
          SizedBox(height: 20),
          Text("Daily: \$${budget.budgetPerDay.toStringAsFixed(2)}"),
          SizedBox(height: 5),
          Text("Weekly: \$${(budget.budgetPerDay * 7).toStringAsFixed(2)}"),
          SizedBox(height: 5),
          Text("Monthly (30 days): \$${(budget.budgetPerDay * 30).toStringAsFixed(2)}"),
          SizedBox(height: 5),
          Text("Yearly (365 days): \$${(budget.budgetPerDay * 365).toStringAsFixed(2)}"),
        ],
      ),
      actions: [
        FlatButton(onPressed: _onSaveButton, child: Text("Save")),
        FlatButton(onPressed: _onCancelButton, child: Text("Cancel")),
      ],
    );
  }

  /// Event called when the budget input value was changed.
  void _onBudgetChanged(String value) {
    setBudget(value);
  }

  /// Event called when save button was clicked.
  void _onSaveButton() {
    saveBudget();
  }

  /// Event called when cancel button was clicked.
  void _onCancelButton() {
    closePopup(null);
  }
}
