import 'package:expense_tracker/ui/navigations/AppRouteInfoParser.dart';
import 'package:expense_tracker/ui/navigations/AppRouterDelegate.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Expense Tracker",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      routeInformationParser: AppRouteInfoParser(),
      routerDelegate: AppRouterDelegate(),
    );
  }
}
