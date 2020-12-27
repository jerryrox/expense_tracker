import 'package:flutter/material.dart';

class LinedDivider extends StatelessWidget {
  LinedDivider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 1,
      color: theme.disabledColor.withAlpha(31),
    );
  }
}
