import 'package:expense_tracker/modules/models/PathUtils.dart';
import 'package:expense_tracker/modules/models/navigations/PathSegment.dart';

/// Class which stores and manipulates path segments for use in navigations.
class NavigationPath {

  final List<PathSegment> _segments = [];


  /// Returns the number of segments in the path.
  int get length => _segments.length;

  /// Returns the raw path built from the segments.
  String get rawPath => PathUtils.combineSegments(_segments.map((e) => e.segment).toList());


  NavigationPath.withPath(String path) {
    this._segments.addAll(PathUtils.parseSegments(path).map((e) => PathSegment(e)));
  }

  NavigationPath.withSegments(List<String> segments) {
    this._segments.addAll(segments.map((e) => PathSegment(e)));
  }

  /// Return the segment at the specified index.
  PathSegment getSegment(int index) {
    return _segments[index];
  }

  /// Returns the path after replacing all the param keys with the values from specified map.
  String getPathWithParams(Map<String, String> params) {
    return PathUtils.combineSegments(_segments.map((e) {
      if(e.isKey) {
        final key = e.key;
        if(!params.containsKey(key)) {
          throw "There is no parameter value matching the key (${key}).";
        }
        return params[key];
      }
      return e.segment;
    }).toList());
  }
}