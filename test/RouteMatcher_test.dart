import 'package:expense_tracker/modules/models/navigations/RouteMatcher.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Instantiation with empty path", () {
    expect(RouteMatcher(null).paths.length, equals(0));
    expect(RouteMatcher("").paths.length, equals(0));
    expect(RouteMatcher("/").paths.length, equals(0));
  });
  test("Instantiation with multiple paths", () {
    expect(RouteMatcher("asdf").paths.length, equals(1));
    expect(RouteMatcher("asdf").paths[0], equals("asdf"));

    expect(RouteMatcher("a/b").paths.length, equals(2));
    expect(RouteMatcher("a/b").paths[0], equals("a"));
    expect(RouteMatcher("a/b").paths[1], equals("b"));

    expect(RouteMatcher("a/:b").paths.length, equals(2));

    expect(RouteMatcher("a/b a").paths[0], equals("a"));
    expect(RouteMatcher("a/b a").paths[1], equals("b a"));
  });
  test("Matching with non-exact and non-case-sensitive", () {
    var matcher = RouteMatcher(null, isExact: false, isCaseSensitive: false);
    expect(matcher.getMatch("").isMatching, isTrue);
    expect(matcher.getMatch("").params.isEmpty, isTrue);
    expect(matcher.getMatch(null).isMatching, isTrue);
    expect(matcher.getMatch(null).params.isEmpty, isTrue);
    expect(matcher.getMatch("/").isMatching, isTrue);
    expect(matcher.getMatch("/").params.isEmpty, isTrue);

    expect(matcher.getMatch("a").isMatching, isFalse);
    expect(matcher.getMatch("a").params.isEmpty, isTrue);
    expect(matcher.getMatch("a/b").isMatching, isFalse);
    expect(matcher.getMatch("a/b").params.isEmpty, isTrue);
    expect(matcher.getMatch(":a").isMatching, isFalse);
    expect(matcher.getMatch(":a").params.isEmpty, isTrue);

    matcher = RouteMatcher("a", isExact: false, isCaseSensitive: false);
    expect(matcher.getMatch("a").isMatching, isTrue);
    expect(matcher.getMatch("a").params.isEmpty, isTrue);
    expect(matcher.getMatch("A").isMatching, isTrue);
    expect(matcher.getMatch("A").params.isEmpty, isTrue);
    expect(matcher.getMatch("/a").isMatching, isTrue);
    expect(matcher.getMatch("/a").params.isEmpty, isTrue);
    expect(matcher.getMatch("/A").isMatching, isTrue);
    expect(matcher.getMatch("/A").params.isEmpty, isTrue);

    expect(matcher.getMatch("/").isMatching, isFalse);
    expect(matcher.getMatch("/").params.isEmpty, isTrue);
    expect(matcher.getMatch("a/b").isMatching, isFalse);
    expect(matcher.getMatch("a/b").params.isEmpty, isTrue);

    matcher = RouteMatcher("a/b/c", isExact: false, isCaseSensitive: false);
    expect(matcher.getMatch("A/b/C").isMatching, isTrue);
    expect(matcher.getMatch("A/b/C").params.isEmpty, isTrue);
    expect(matcher.getMatch("A/b/C").isMatching, isTrue);
    expect(matcher.getMatch("A/b/C").params.isEmpty, isTrue);

    matcher = RouteMatcher("a/:b", isExact: false, isCaseSensitive: false);
    expect(matcher.getMatch("A/asdf").isMatching, isTrue);
    expect(matcher.getMatch("A/asdf").params["b"], equals("asdf"));
    expect(matcher.getMatch("a/B").isMatching, isTrue);
    expect(matcher.getMatch("a/B").params["b"], equals("B"));

    expect(matcher.getMatch("A/").isMatching, isFalse);
    expect(matcher.getMatch("A/").params.isEmpty, isTrue);
  });
  test("Matching with exact", () {
    var matcher = RouteMatcher(":a", isExact: true, isCaseSensitive: false);
    expect(matcher.getMatch(":a").isMatching, isTrue);
    expect(matcher.getMatch(":a").params.isEmpty, isTrue);
    expect(matcher.getMatch("a").isMatching, isFalse);
    expect(matcher.getMatch("a").params.isEmpty, isTrue);
  });
  test("Matching with case-sensitive", () {
    var matcher = RouteMatcher("A/b/C", isExact: false, isCaseSensitive: true);
    expect(matcher.getMatch("a/b/c").isMatching, isFalse);
    expect(matcher.getMatch("A/b/c").isMatching, isFalse);
    expect(matcher.getMatch("a/b/C").isMatching, isFalse);
    expect(matcher.getMatch("A/b/C").isMatching, isTrue);
  });
}