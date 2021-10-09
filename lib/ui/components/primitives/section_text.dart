import 'package:flutter/material.dart';

class SectionText extends StatelessWidget {
  final String text;

  SectionText(this.text, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 17,
      ),
    );
  }
}
