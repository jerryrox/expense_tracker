import 'package:expense_tracker/modules/models/PathUtils.dart';
import 'package:expense_tracker/modules/models/navigations/NavigationPath.dart';
import 'package:expense_tracker/modules/models/navigations/RouteMatchInfo.dart';

/// Class which compares the inputted path to see if it matches the condition for routing.
class RouteMatcher {

  NavigationPath path;
  bool isExact;
  bool isCaseSensitive;

  RouteMatcher(String path, {this.isExact = false, this.isCaseSensitive = false}) {
    this.path = NavigationPath.withPath(path);
  }

  /// Returns the match information by evaluating the specified location.
  RouteMatchInfo getMatch(String location) {
    final segments = PathUtils.parseSegments(location ?? "");
    if(segments.length != path.length) {
      return RouteMatchInfo.noMatch();
    }
    
    Map<String, String> params = {};
    for(int i=0; i<path.length; i++) {
      final targetSegment = path.getSegment(i);
      final curSegment = segments[i];

      if(isExact) {
        if(!_isMatchingPaths(targetSegment.segment, curSegment)) {
          return RouteMatchInfo.noMatch();
        }
      }
      else {
        if(targetSegment.isKey) {
          params[targetSegment.key] = curSegment;
        }
        else {
          if(!_isMatchingPaths(targetSegment.segment, curSegment)) {
            return RouteMatchInfo.noMatch();
          }
        }
      }
    }
    return RouteMatchInfo.match(params);
  }

  /// Returns whether the two paths are considered matching.
  bool _isMatchingPaths(String x, String y) {
    if(isCaseSensitive) {
      return x == y;
    }
    return x.toLowerCase() == y.toLowerCase();
  }
}