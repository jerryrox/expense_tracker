import 'package:flutter/material.dart';

class ContentPadding extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final Widget child;

  ContentPadding({
    Key key,
    this.top = 0,
    this.bottom = 0,
    this.left = 40,
    this.right = 40,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        bottom: bottom,
        left: left,
        right: right,
      ),
      child: child,
    );
  }
}
