import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:flutter/material.dart';

class FilledBox extends StatefulWidget {
  final Widget child;
  
  FilledBox({Key key, this.child}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _FilledBoxState();
}

class _FilledBoxState extends State<FilledBox> with UtilMixin {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: widget.child,
      );
    });
  }
}