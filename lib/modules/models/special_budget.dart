import 'package:expense_tracker/modules/models/budget.dart';
import 'package:expense_tracker/modules/models/date_range.dart';

class SpecialBudget extends Budget {
  String id;
  DateRange range;
  /// The amount of budget available for the time frame.
  double budget;

  @override
  int get days => range.days;

  SpecialBudget({this.id, this.range, this.budget}) : super(budget);
}