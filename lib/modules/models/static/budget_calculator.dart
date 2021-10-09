import 'package:expense_tracker/modules/models/date_range.dart';
import 'package:expense_tracker/modules/models/default_budget.dart';
import 'package:expense_tracker/modules/models/special_budget.dart';

class BudgetCalculator {

  BudgetCalculator._();

  /// Returns the total budget within the range.
  static double getTotalBudget(DefaultBudget defaultBudget, List<SpecialBudget> specialBudgets, DateRange range) {
    int days = range.days;
    double amount = 0;
    for(final special in specialBudgets) {
      final overlap = range.getOverlap(special.range);
      if(overlap != null) {
        amount += overlap.days * special.budgetPerDay;
        days -= overlap.days;
      }
    }
    amount += days * defaultBudget.budgetPerDay;
    return amount;
  }
}