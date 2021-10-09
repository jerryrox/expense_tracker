import 'package:expense_tracker/modules/mixins/util_mixin.dart';
import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget with UtilMixin {
  LoaderOverlay({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      color: Colors.transparent,
      child: Container(
        width: getScreenWidth(context),
        height: getScreenHeight(context),
        color: Color.fromARGB(127, 0, 0, 0),
      ),
    );
  }
}
