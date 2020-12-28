import 'package:expense_tracker/modules/models/DateRange.dart';
import 'package:expense_tracker/modules/types/DateRangeType.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Instantiation", () {
    DateTime now = DateTime.utc(2020, 12, 21, 8);
    expect(DateRange(now, DateRangeType.day).now.year, equals(2020));
    expect(DateRange(now, DateRangeType.day).now.month, equals(12));
    expect(DateRange(now, DateRangeType.day).now.day, equals(21));
    expect(DateRange(now, DateRangeType.day).now.hour, equals(8));

    expect(DateRange(now, DateRangeType.day).min.year, equals(2020));
    expect(DateRange(now, DateRangeType.day).min.month, equals(12));
    expect(DateRange(now, DateRangeType.day).min.day, equals(21));
    expect(DateRange(now, DateRangeType.day).min.hour, equals(0));

    expect(DateRange(now, DateRangeType.day).max.year, equals(2020));
    expect(DateRange(now, DateRangeType.day).max.month, equals(12));
    expect(DateRange(now, DateRangeType.day).max.day, equals(22));
    expect(DateRange(now, DateRangeType.day).max.hour, equals(0));
  });
  test("setNow", () {
    DateTime now = DateTime.utc(2020, 12, 21);
    DateRange dateRange = DateRange(now, DateRangeType.day);
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(12));
    expect(dateRange.now.day, equals(21));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(21));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(12));
    expect(dateRange.max.day, equals(22));

    dateRange.setNow(DateTime.utc(2020, 10, 4));
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(10));
    expect(dateRange.now.day, equals(4));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(10));
    expect(dateRange.min.day, equals(4));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(10));
    expect(dateRange.max.day, equals(5));
  });
  test("setRangeType", () {
    DateTime now = DateTime.utc(2020, 12, 24);
    DateRange dateRange = DateRange(now, DateRangeType.day);
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(12));
    expect(dateRange.now.day, equals(24));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(24));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(12));
    expect(dateRange.max.day, equals(25));

    dateRange.setRangeType(DateRangeType.week);
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(12));
    expect(dateRange.now.day, equals(24));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(21));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(12));
    expect(dateRange.max.day, equals(28));

    dateRange.setRangeType(DateRangeType.month);
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(12));
    expect(dateRange.now.day, equals(24));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(1));
    expect(dateRange.max.year, equals(2021));
    expect(dateRange.max.month, equals(1));
    expect(dateRange.max.day, equals(1));

    dateRange.setRangeType(DateRangeType.year);
    expect(dateRange.now.year, equals(2020));
    expect(dateRange.now.month, equals(12));
    expect(dateRange.now.day, equals(24));
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(1));
    expect(dateRange.min.day, equals(1));
    expect(dateRange.max.year, equals(2021));
    expect(dateRange.max.month, equals(1));
    expect(dateRange.max.day, equals(1));
  });
}