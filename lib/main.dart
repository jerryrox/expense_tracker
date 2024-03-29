import 'package:expense_tracker/modules/dependencies/dependency_container.dart';
import 'package:expense_tracker/ui/ui_root.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ExpenseTrackerApp());
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({Key key}) : super(key: key);
  
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