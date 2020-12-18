import 'package:expense_tracker/modules/themes/IconAtlas.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  
  SplashScreen({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              IconAtlas.app,
              size: 48,
            ),
            SizedBox(height: 10),
            Text(
              "Expense Tracker",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}