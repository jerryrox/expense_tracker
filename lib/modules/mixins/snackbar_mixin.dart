import 'package:flutter/material.dart';

class SnackbarMixin {
  // Shows a simple snackbar with a message.
  showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
