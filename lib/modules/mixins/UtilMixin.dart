import 'package:flutter/material.dart';

class UtilMixin {
  /// Returns the width of the screen.
  double getScreenWidth(BuildContext context) {
    final query = MediaQuery.of(context);
    return query.size.width;// + query.viewPadding.horizontal;
  }

  /// Returns the height of the screen.
  double getScreenHeight(BuildContext context) {
    final query = MediaQuery.of(context);
    return query.size.height;// + query.viewPadding.vertical;
  }

  /// Removes focus from whatever widget concerned.
  void removeFocus(BuildContext context) {
    FocusScopeNode node = FocusScope.of(context);
    if (!node.hasPrimaryFocus && node.focusedChild != null) {
      node.focusedChild.unfocus();
    }
  }

  /// Dispatches an event to be called after the first frame render.
  void afterFrameRender(Function function) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      function.call();
    });
  }
}
