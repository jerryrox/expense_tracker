import 'package:expense_tracker/ui/components/primitives/RoundedButton.dart';
import 'package:flutter/material.dart';

/// RoundedButton variant that draws a Text as a child.
class TextRoundedButton extends StatelessWidget {
  final String text;

  final bool isOutlined;
  final bool isFullWidth;
  final Function() onClick;

  TextRoundedButton(
    this.text, {
    Key key,
    this.isOutlined = false,
    this.isFullWidth = false,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RoundedButton(
      isFullWidth: isFullWidth,
      isOutlined: isOutlined,
      onClick: onClick,
      child: Text(
        text,
        style: TextStyle(
          color: isOutlined ? theme.primaryColor : theme.scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
