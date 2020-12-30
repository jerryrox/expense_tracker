abstract class Budget {

  /// The total available budget within the time frame.
  double totalBudget;

  /// Returns the number of days the special budget lasts for.
  int get days;

  /// Returns the amount of budget per day.
  double get budgetPerDay => totalBudget / days.toDouble();

  Budget(this.totalBudget);
}