import 'package:flutter/material.dart';

class PageTopMargin extends StatelessWidget {
  final double height;

  PageTopMargin({
    Key key,
    this.height = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}
