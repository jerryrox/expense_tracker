class SpecialBudget {
  String id;
  /// The inclusive date from which the budget applies.
  DateTime start;
  /// The exclusive date to which the budget applies.
  DateTime end;
  /// The amount of budget available for this week.
  double budget;

  /// Returns the number of days the special budget lasts for.
  int get days => end.difference(start).inDays;

  /// Returns the amount of budget per day.
  double get budgetPerDay => budget / days.toDouble();

  SpecialBudget({this.id, this.start, this.end, this.budget});
}