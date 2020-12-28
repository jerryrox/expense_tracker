import 'package:expense_tracker/modules/types/DateRangeType.dart';

class DateRange {

  DateTime _now;
  DateTime _min;
  DateTime _max;
  DateRangeType _rangeType;

  /// Returns the current datetime in UTC.
  DateTime get now => _now;

  /// Returns the inclusive lower end of the date range in UTC.
  DateTime get min => _min;

  /// Returns the exclusive upper end of the date range in UTC.
  DateTime get max => _max;

  /// Returns the current range type the date ranges were evaluated for.
  DateRangeType get rangeType => _rangeType;

  DateRange(DateTime now, DateRangeType rangeType) {
    this._now = now.toUtc();
    this._rangeType = rangeType;
    _evaluateRange();
  }

  /// Sets the current date time to calculate the range from.
  void setNow(DateTime dateTime) {
    _now = dateTime.toUtc();
    _evaluateRange();
  }

  /// Sets the date range type to modify the state values.
  void setRangeType(DateRangeType rangeType) {
    this._rangeType = rangeType;
    _evaluateRange();
  }

  void _evaluateRange() {
    switch(_rangeType) {
      case DateRangeType.day:
        _min = DateTime.utc(_now.year, _now.month, _now.day);
        _max = DateTime.utc(_now.year, _now.month, _now.day + 1);
        break;

      case DateRangeType.week:
        _min = DateTime.utc(_now.year, _now.month, _now.day + 1 - _now.weekday);
        _max = DateTime.utc(_now.year, _now.month, _now.day + 8 - _now.weekday);
        break;

      case DateRangeType.month:
        _min = DateTime.utc(_now.year, _now.month);
        _max = DateTime.utc(_now.year, _now.month + 1);
        break;

      case DateRangeType.year:
        _min = DateTime.utc(_now.year);
        _max = DateTime.utc(_now.year + 1);
        break;
    }
  }
}