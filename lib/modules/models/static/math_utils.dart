import 'dart:math';

class MathUtils {

  static Random _random = Random();

  MathUtils._();

  /// Returns a random integer between the specified min (inclusive) and max (exclusive).
  static int randomInt(int min, int max) {
    return _random.nextInt(max - min) + min;
  }

  /// Returns a random double between the specified min (inclusive) and max (exclusive).
  static double randomDouble(double min, double max) {
    return _random.nextDouble() * (max - min) + min;
  }

  /// Returns the absolute value of the specified value.
  static double abs(double value) {
    return value < 0 ? -value : value;
  }
}