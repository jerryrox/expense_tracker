import 'package:flutter/material.dart';

class ButtonWidthConstraint extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  ButtonWidthConstraint({
    Key key,
    this.child,
    this.maxWidth = 300,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );
  }
}
