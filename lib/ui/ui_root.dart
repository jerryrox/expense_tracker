import 'package:expense_tracker/ui/navigations/screens/splash_screen.dart';
import 'package:flutter/material.dart';

class UIRoot extends StatefulWidget {
  
  UIRoot({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _UIRootState();
}

class _UIRootState extends State<UIRoot> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Expense Tracker",
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryTextTheme: TextTheme(
          button: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}