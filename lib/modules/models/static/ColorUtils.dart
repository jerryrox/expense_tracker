import 'package:flutter/material.dart';

class ColorUtils {

  ColorUtils._();

  /// Returns the luminance of the specified color.
  static double getLuminance(Color color) {
    double r = color.red / 255.0;
    double g = color.green / 255.0;
    double b = color.blue / 255.0;
    return r * 0.299 + g * 0.587 + b * 0.114;
  }

  /// Returns the color which contrasts with the specified color as background.
  static Color getTextColorForBg(Color bgColor) {
    return getLuminance(bgColor) < 0.5 ? Colors.white : Colors.black;
  }
}