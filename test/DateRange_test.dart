import 'package:expense_tracker/modules/models/date_range.dart';
import 'package:expense_tracker/modules/types/date_range_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Empty constructor", () {
    final dateRange = DateRange();
    expect(dateRange.min, equals(dateRange.max));
  });
  test("withMinMax", () {
    final range = DateRange.withMinMax(DateTime.utc(2020, 1, 2), DateTime.utc(2021, 2, 8));
    expect(range.min.year, equals(2020));
    expect(range.min.month, equals(1));
    expect(range.min.day, equals(2));
    expect(range.max.year, equals(2021));
    expect(range.max.month, equals(2));
    expect(range.max.day, equals(8));

    expect(
      DateRange.withMinMax(DateTime.utc(2020, 1, 2), DateTime.utc(2020, 1, 7)).days,
      equals(5),
    );
  });
  test("withDateRange", () {
    DateTime now = DateTime.utc(2020, 12, 24);
    DateRange dateRange = DateRange.withDateRange(now, DateRangeType.day);
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(24));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(12));
    expect(dateRange.max.day, equals(25));

    dateRange = DateRange.withDateRange(now, DateRangeType.week);
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(21));
    expect(dateRange.max.year, equals(2020));
    expect(dateRange.max.month, equals(12));
    expect(dateRange.max.day, equals(28));

    dateRange = DateRange.withDateRange(now, DateRangeType.month);
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(12));
    expect(dateRange.min.day, equals(1));
    expect(dateRange.max.year, equals(2021));
    expect(dateRange.max.month, equals(1));
    expect(dateRange.max.day, equals(1));

    dateRange = DateRange.withDateRange(now, DateRangeType.year);
    expect(dateRange.min.year, equals(2020));
    expect(dateRange.min.month, equals(1));
    expect(dateRange.min.day, equals(1));
    expect(dateRange.max.year, equals(2021));
    expect(dateRange.max.month, equals(1));
    expect(dateRange.max.day, equals(1));
  });
  test("getOverlap", () {
    DateRange rangeA = DateRange.withMinMax(DateTime.utc(2020, 1, 1), DateTime.utc(2020, 1, 5));
    DateRange rangeB = DateRange.withMinMax(DateTime.utc(2020, 1, 5), DateTime.utc(2020, 1, 6));
    DateRange resultA = rangeA.getOverlap(rangeB);
    DateRange resultB = rangeB.getOverlap(rangeA);
    expect(resultA, isNull);
    expect(resultB, isNull);

    rangeA = DateRange.withMinMax(DateTime.utc(2020, 1, 1), DateTime.utc(2020, 1, 5));
    rangeB = DateRange.withMinMax(DateTime.utc(2020, 1, 1), DateTime.utc(2020, 1, 3));
    resultA = rangeA.getOverlap(rangeB);
    resultB = rangeB.getOverlap(rangeA);
    expect(resultA, isNotNull);
    expect(resultB, isNotNull);
    expect(resultA.days, equals(2));
    expect(resultB.days, equals(2));
    expect(resultA.min, equals(resultB.min));
    expect(resultA.max, equals(resultB.max));
    expect(resultA.min, equals(DateTime.utc(2020, 1, 1)));
    expect(resultA.max, equals(DateTime.utc(2020, 1, 3)));

    rangeA = DateRange.withMinMax(DateTime.utc(2020, 1, 4), DateTime.utc(2020, 1, 8));
    rangeB = DateRange.withMinMax(DateTime.utc(2020, 1, 1), DateTime.utc(2020, 1, 5));
    resultA = rangeA.getOverlap(rangeB);
    expect(resultA.min, equals(DateTime.utc(2020, 1, 4)));
    expect(resultA.max, equals(DateTime.utc(2020, 1, 5)));

    rangeA = DateRange.withMinMax(DateTime.utc(2020, 1, 4), DateTime.utc(2020, 1, 8));
    rangeB = DateRange.withMinMax(DateTime.utc(2020, 1, 5), DateTime.utc(2020, 1, 7));
    resultA = rangeA.getOverlap(rangeB);
    expect(resultA.min, equals(DateTime.utc(2020, 1, 5)));
    expect(resultA.max, equals(DateTime.utc(2020, 1, 7)));
  });
}