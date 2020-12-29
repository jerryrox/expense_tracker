import 'package:expense_tracker/modules/api/getDefaultBudget/GetDefaultBudgetApi.dart';
import 'package:expense_tracker/modules/api/getSpecialBudgets/GetSpecialBudgetsApi.dart';
import 'package:expense_tracker/modules/models/Bindable.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';

class BudgetState {

  final Bindable<DefaultBudget> defaultBudget = Bindable(null);
  final Bindable<List<SpecialBudget>> specialBudgets = Bindable([]);

  /// Returns whether the budget has been set up.
  bool get isBudgetSetup => defaultBudget.value != null;

  /// Loads budget data from server while syncing the state.
  Future loadBudget(String uid) async {
    final api = GetDefaultBudgetApi(uid);
    final budget = await api.request();
    defaultBudget.value = budget;
  }

  /// Loads the list of special budgets from server while syncing the state.
  Future loadSpecialBudgets(String uid) async {
    final api = GetSpecialBudgetsApi(uid).fromThisYear();
    final budgets = await api.request();
    specialBudgets.value = budgets;
  }
}