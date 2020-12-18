class PathSegment {

  final String segment;

  /// Returns the path param key, if this segment represents it.
  String get key => isKey ? segment.substring(1) : null;

  /// Returns whether this segment is a path param key.
  bool get isKey => segment.startsWith(":");

  PathSegment(this.segment);
}