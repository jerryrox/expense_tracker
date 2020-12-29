import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/models/DefaultBudget.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';

class BudgetCalculator {

  DefaultBudget defaultBudget;
  List<SpecialBudget> specialBudgets;
  DateRange range;

  BudgetCalculator(this.defaultBudget, this.specialBudgets, this.range);

  /// Returns the total budget within the range.
  double getTotalBudget() {
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