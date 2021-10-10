import 'package:expense_tracker/modules/models/budget.dart';

class DefaultBudget extends Budget {

  @override
  int get days => 7;

  DefaultBudget(double weeklyAmount) : super(weeklyAmount);
}