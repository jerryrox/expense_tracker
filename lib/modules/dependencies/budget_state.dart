import 'package:expense_tracker/modules/api/get_default_budget/get_default_budget_api.dart';
import 'package:expense_tracker/modules/api/get_special_budgets/get_special_budgets_api.dart';
import 'package:expense_tracker/modules/models/default_budget.dart';
import 'package:expense_tracker/modules/models/special_budget.dart';

class BudgetState {

  DefaultBudget defaultBudget = DefaultBudget(0);
  List<SpecialBudget> specialBudgets = [];

  /// Returns whether the budget has been set up.
  bool get isBudgetSetup => defaultBudget.totalBudget > 0;

  /// Loads budget data from server while syncing the state.
  Future<DefaultBudget> loadBudget(String uid) async {
    final api = GetDefaultBudgetApi(uid);
    final budget = await api.request();
    defaultBudget = budget;
    return budget;
  }

  /// Loads the list of special budgets from server while syncing the state.
  Future<List<SpecialBudget>> loadSpecialBudgets(String uid) async {
    final api = GetSpecialBudgetsApi(uid).fromThisYear();
    final budgets = await api.request();
    specialBudgets = budgets;
    return budgets;
  }
}