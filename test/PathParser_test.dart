import 'package:expense_tracker/modules/models/PathParser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("parse", () {
    var results = PathParser.parse(null);
    expect(results.length, equals(0));

    results = PathParser.parse("");
    expect(results.length, equals(0));

    results = PathParser.parse("/");
    expect(results.length, equals(0));

    results = PathParser.parse("//");
    expect(results.length, equals(0));

    results = PathParser.parse(" / / ");
    expect(results.length, equals(0));

    results = PathParser.parse("b");
    expect(results.length, equals(1));
    expect(results[0], equals("b"));
    results = PathParser.parse("/b");
    expect(results.length, equals(1));
    expect(results[0], equals("b"));
    results = PathParser.parse("/b/c");
    expect(results.length, equals(2));
    expect(results[0], equals("b"));
    expect(results[1], equals("c"));
    results = PathParser.parse("a/b/:c");
    expect(results.length, equals(3));
    expect(results[0], equals("a"));
    expect(results[1], equals("b"));
    expect(results[2], equals(":c"));
  });
}