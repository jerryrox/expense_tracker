import 'package:expense_tracker/modules/types/date_range_type.dart';
import 'package:localstorage/localstorage.dart';

class Prefs {

  final LocalStorage storage = LocalStorage("prefs");

  /// Returns the last selected date range type for the overview.
  DateRangeType get lastDateRangeType {
    return DateRangeType.values[getInt("lastDateRangeType", DateRangeType.values.indexOf(DateRangeType.week))];
  }
  /// Sets the last selected date range type for the overview.
  set lastDateRangeType(DateRangeType type) {
    setInt("lastDateRangeType", DateRangeType.values.indexOf(type));
  }

  double get conversionRate {
    return getDouble("conversionRate", 1);
  }
  set conversionRate(double value) {
    setDouble("conversionRate", value);
  }

  /// Initializes the local storage for use.
  Future initialize() async {
    await storage.ready;
  }

  /// Returns an integer value from the specified key.
  int getInt(String key, [int defaultValue = 0]) {
    try {
      return (storage.getItem(key).toInt() as int) ?? defaultValue;
    }
    catch(e) {
      return defaultValue;
    }
  }

  /// Sets an integer value for the specified key.
  void setInt(String key, int value) {
    storage.setItem(key, value);
  }

  double getDouble(String key, [double defaultValue = 0]) {
    try {
      return (storage.getItem(key).toDouble() as double) ?? defaultValue;
    }
    catch(e) {
      return defaultValue;
    }
  }
  void setDouble(String key, double value) {
    storage.setItem(key, value);
  }
}