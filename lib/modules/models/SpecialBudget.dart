import 'package:expense_tracker/modules/models/Budget.dart';
import 'package:expense_tracker/modules/models/DateRange.dart';

class SpecialBudget extends Budget {
  String id;
  DateRange range;
  /// The amount of budget available for the time frame.
  double budget;

  @override
  int get days => range.days;

  SpecialBudget({this.id, this.range, this.budget}) : super(budget);
}