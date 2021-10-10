import 'package:expense_tracker/modules/models/static/path_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("parseSegments", () {
    var results = PathUtils.parseSegments(null);
    expect(results.length, equals(0));

    results = PathUtils.parseSegments("");
    expect(results.length, equals(0));

    results = PathUtils.parseSegments("/");
    expect(results.length, equals(0));

    results = PathUtils.parseSegments("//");
    expect(results.length, equals(0));

    results = PathUtils.parseSegments(" / / ");
    expect(results.length, equals(0));

    results = PathUtils.parseSegments("b");
    expect(results.length, equals(1));
    expect(results[0], equals("b"));
    results = PathUtils.parseSegments("/b");
    expect(results.length, equals(1));
    expect(results[0], equals("b"));
    results = PathUtils.parseSegments("/b/c");
    expect(results.length, equals(2));
    expect(results[0], equals("b"));
    expect(results[1], equals("c"));
    results = PathUtils.parseSegments("a/b/:c");
    expect(results.length, equals(3));
    expect(results[0], equals("a"));
    expect(results[1], equals("b"));
    expect(results[2], equals(":c"));
  });
  test("combineSegments", () {
    expect(PathUtils.combineSegments(null), equals("/"));
    expect(PathUtils.combineSegments([]), equals("/"));
    expect(PathUtils.combineSegments([""]), equals("/"));
    expect(PathUtils.combineSegments([" "]), equals("/"));
    expect(PathUtils.combineSegments(["abc"]), equals("/abc"));
    expect(PathUtils.combineSegments([" abc "]), equals("/abc"));
    expect(PathUtils.combineSegments(["a", "b", "cc"]), equals("/a/b/cc"));
    expect(PathUtils.combineSegments(["a", "", "cc"]), equals("/a/cc"));
    expect(PathUtils.combineSegments(["a", " ", "cc"]), equals("/a/cc"));
    expect(PathUtils.combineSegments(["a", null, "cc"]), equals("/a/cc"));

    expect(PathUtils.combineSegments(null, leadSlash: false), equals(""));
    expect(PathUtils.combineSegments(["a", null, "cc"], leadSlash: false), equals("a/cc"));
  });
}