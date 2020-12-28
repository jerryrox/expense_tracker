import 'package:expense_tracker/modules/models/Bindable.dart';
import 'package:expense_tracker/modules/models/SpecialBudget.dart';

class BudgetState {

  final Bindable<double> baseBudget = Bindable(0);
  final Bindable<List<SpecialBudget>> specialBudgets = Bindable([]);


}