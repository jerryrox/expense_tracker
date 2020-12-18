import 'package:expense_tracker/modules/dependencies/DependencyContainer.dart';
import 'package:expense_tracker/ui/UIRoot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  
  ExpenseTrackerApp({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {

  DependencyContainer dependencies;

  @override
  void initState() {
    super.initState();

    dependencies = DependencyContainer();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: dependencies.getProviders(),
      child: UIRoot(),
    );
  }
}