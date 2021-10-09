import 'dart:math';

import 'package:expense_tracker/modules/models/date_range.dart';
import 'package:expense_tracker/modules/models/default_budget.dart';
import 'package:expense_tracker/modules/models/record.dart';
import 'package:expense_tracker/modules/models/special_budget.dart';
import 'package:expense_tracker/modules/models/static/budget_calculator.dart';
import 'package:flutter/material.dart';

class MoneyUsageData {

  double totalSpent = 0;
  double totalBudget = 0;
  double budgetToDate = 0;

  double get overspent => max(totalSpent - budgetToDate, 0);

  double get saved => max(budgetToDate - totalSpent, 0);

  double get remainingTotalBudget => max(totalBudget - totalSpent, 0);

  MoneyUsageData({
    @required Iterable<Record> records,
    @required DefaultBudget defaultBudget,
    @required List<SpecialBudget> specialBudgets,
    @required DateRange dateRange,
    @required DateTime now,
  }) {
    for (final record in records) {
      totalSpent += record.price;
    }
    totalBudget = BudgetCalculator.getTotalBudget(
      defaultBudget,
      specialBudgets,
      dateRange,
    );
    budgetToDate = BudgetCalculator.getTotalBudget(
      defaultBudget,
      specialBudgets,
      DateRange.withMinMax(dateRange.min, now.add(Duration(days: 1))),
    );
  }
}