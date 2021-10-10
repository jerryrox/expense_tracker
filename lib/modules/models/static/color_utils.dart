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

  /// Darkens the specified color by a factor, ranging from 0 (same) to 1 (black).
  static Color darken(Color color, double factor) {
    factor = 1 - factor;
    double r = factor * color.red;
    double g = factor * color.green;
    double b = factor * color.blue;
    return Color.fromARGB(color.alpha, r.toInt(), g.toInt(), b.toInt());
  }

  /// Darkens the specified color by a factor, ranging from 0 (same) to 1 (white).
  static Color brighten(Color color, double factor) {
    double r = factor * (255.0 - color.red) + color.red;
    double g = factor * (255.0 - color.green) + color.green;
    double b = factor * (255.0 - color.blue) + color.blue;
    return Color.fromARGB(color.alpha, r.toInt(), g.toInt(), b.toInt());
  }
}