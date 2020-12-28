import 'package:flutter/material.dart';

class BottomContentPadding extends StatelessWidget {
  final double top;
  final double bottom;
  final double left;
  final double right;
  final Widget child;

  BottomContentPadding({
    Key key,
    this.top = 20,
    this.bottom = 20,
    this.left = 0,
    this.right = 0,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: top,
        left: left,
        bottom: bottom,
        right: right,
      ),
      child: child,
    );
  }
}
