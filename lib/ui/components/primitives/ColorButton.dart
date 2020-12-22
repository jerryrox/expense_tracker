import 'package:flutter/material.dart';

class ColorButton extends StatelessWidget {
  final double size;
  final Color color;
  final Function() onClick;

  ColorButton({
    Key key,
    this.size = 32,
    this.color,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1000),
        color: color,
      ),
      height: size,
      width: size,
      child: InkWell(
        onTap: onClick,
        child: Container(),
      ),
    );
  }
}
