import 'package:flutter/material.dart';

class DialogMixin {
  /// Shows a dialog with default options and specified child.
  Future<T> showDialogDefault<T>(BuildContext context, Widget child) {
    return showDialog(context: context, builder: (context) => child);
  }
}
