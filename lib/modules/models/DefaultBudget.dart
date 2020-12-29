import 'package:expense_tracker/modules/models/Budget.dart';

class DefaultBudget extends Budget {

  @override
  int get days => 7;

  DefaultBudget(double weeklyAmount) : super(weeklyAmount);
}