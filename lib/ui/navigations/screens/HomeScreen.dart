import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  
  HomeScreen({Key key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Content"),
      ),
    );
  }
}