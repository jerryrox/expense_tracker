import 'package:expense_tracker/ui/navigations/overlays/LoaderOverlay.dart';
import 'package:flutter/material.dart';

class LoaderMixin {

  /// Shows a loader overlay and return the overlay entry for control.
  OverlayEntry showLoader(BuildContext context) {
    final entry = OverlayEntry(builder: (context) => LoaderOverlay());
    Overlay.of(context).insert(entry);
    return entry;
  }
}