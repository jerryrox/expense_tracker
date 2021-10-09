class DynamicUtils {

  DynamicUtils._();

  /// Returns the specified value as a double.
  static double getDouble(dynamic value) {
    return value.toDouble() as double;
  }
}