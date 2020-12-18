import 'package:expense_tracker/modules/dependencies/ScreenManager.dart';
import 'package:expense_tracker/ui/UIRoot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  
  ExpenseTrackerApp({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {

  ScreenManager screenManager;

  @override
  void initState() {
    super.initState();

    screenManager = ScreenManager();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: screenManager),
      ],
      child: UIRoot(),
    );
  }
}