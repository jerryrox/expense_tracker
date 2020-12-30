import 'package:expense_tracker/modules/types/DateRangeType.dart';

class DateRange {

  DateTime _min;
  DateTime _max;

  /// Returns the inclusive lower end of the date range in UTC.
  DateTime get min => _min;

  /// Returns the exclusive upper end of the date range in UTC.
  DateTime get max => _max;

  /// Returns the number of days between min and max date ranges.
  int get days => _max.difference(_min).inDays;


  DateRange() {
    final now = DateTime.now().toUtc();
    this._min = now;
    this._max = now;
  }

  DateRange.withMinMax(DateTime min, DateTime max) {
    this._min = min;
    this._max = max;
  }

  DateRange.withDateRange(DateTime date, DateRangeType type) {
    switch(type) {
      case DateRangeType.day:
        _min = DateTime.utc(date.year, date.month, date.day);
        _max = DateTime.utc(date.year, date.month, date.day + 1);
        break;

      case DateRangeType.week:
        _min = DateTime.utc(date.year, date.month, date.day + 1 - date.weekday);
        _max = DateTime.utc(date.year, date.month, date.day + 8 - date.weekday);
        break;

      case DateRangeType.month:
        _min = DateTime.utc(date.year, date.month);
        _max = DateTime.utc(date.year, date.month + 1);
        break;

      case DateRangeType.year:
        _min = DateTime.utc(date.year);
        _max = DateTime.utc(date.year + 1);
        break;
    }
  }

  /// Returns the overlapping range of dates between this and the specified ranges.
  /// May return [null] if there is no overlap.
  DateRange getOverlap(DateRange other) {
    return _getOverlapInternal(this, other) ?? _getOverlapInternal(other, this);
  }

  /// Checks overlap assuming the other's min date is on or after base's min.
  DateRange _getOverlapInternal(DateRange base, DateRange other) {
    if(!other.min.isBefore(base.min) && other.min.isBefore(base.max)) {
      if(other.max.isBefore(base.max)) {
        // Other range is contained within base range.
        return DateRange.withMinMax(other.min, other.max);
      }
      // Other range's max date is past base range's max.
      return DateRange.withMinMax(other.min, base.max);
    }
    return null;
  }
}