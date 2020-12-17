import 'package:expense_tracker/modules/models/PathParser.dart';
import 'package:expense_tracker/modules/models/navigations/RouteMatchInfo.dart';

/// Class which compares the inputted path to see if it matches the condition for routing.
class RouteMatcher {

  List<String> paths;
  bool isExact;
  bool isCaseSensitive;

  RouteMatcher(String path, {this.isExact = false, this.isCaseSensitive = false}) {
    this.paths = PathParser.parse(path ?? "");
  }

  /// Returns the match information by evaluating the specified location.
  RouteMatchInfo getMatch(String location) {
    final segments = PathParser.parse(location ?? "");
    if(segments.length != paths.length) {
      return RouteMatchInfo.noMatch();
    }
    
    Map<String, String> params = {};
    for(int i=0; i<paths.length; i++) {
      final targetPath = paths[i];
      final curPath = segments[i];

      if(isExact) {
        if(!_isMatchingPaths(targetPath, curPath)) {
          return RouteMatchInfo.noMatch();
        }
      }
      else {
        if(_isParamPath(targetPath)) {
          params[getParamName(targetPath)] = curPath;
        }
        else {
          if(!_isMatchingPaths(targetPath, curPath)) {
            return RouteMatchInfo.noMatch();
          }
        }
      }
    }
    return RouteMatchInfo.match(params);
  }

  /// Returns the name of the parameter key for the specified param path.
  String getParamName(String path) {
    return path.substring(1);
  }

  /// Returns whether the specified path represents a placeholder for the route parameter.
  bool _isParamPath(String path) {
    return path.startsWith(":");
  }

  /// Returns whether the two paths are considered matching.
  bool _isMatchingPaths(String x, String y) {
    if(isCaseSensitive) {
      return x == y;
    }
    return x.toLowerCase() == y.toLowerCase();
  }
}