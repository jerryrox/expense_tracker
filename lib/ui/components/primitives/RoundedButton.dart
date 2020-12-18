import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final Widget child;
  final bool isOutlined;
  final bool isFullWidth;
  final Function() onClick;

  RoundedButton({
    Key key,
    this.child,
    this.isOutlined = false,
    this.isFullWidth = true,
    this.onClick,
  }) : super(key: key);

  /// Returns the actual content of this widget.
  Widget getContent(BuildContext context) {
    final theme = Theme.of(context);

    return Ink(
      decoration: BoxDecoration(
        border: Border.all(
          color: theme.primaryColor,
          style: BorderStyle.solid,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(1000),
        color: isOutlined ? Colors.transparent : theme.primaryColor,
      ),
      child: InkWell(
        onTap: onClick,
        borderRadius: BorderRadius.circular(1000),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isFullWidth) {
      return LayoutBuilder(builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          child: getContent(context),
        );
      });
    }
    return getContent(context);
  }
}
