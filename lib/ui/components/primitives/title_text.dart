import 'package:flutter/material.dart';

class TitleText extends StatelessWidget {
  final String text;
  
  TitleText(this.text, {Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 16),
      child: Row(
        children: [
          Text(
            text ?? "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
        ],
      ),
    );
  }
}