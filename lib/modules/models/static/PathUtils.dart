class PathUtils {

  PathUtils._();

  /// Returns the list of path segments for the specified path.
  /// Uri.parse does not work when there is a column in the path.
  /// Therefore, this logic had to be built manually.
  static List<String> parseSegments(String path) {
    if(path == null) {
      return [];
    }
    
    List<String> segments = path.split("/");
    for(int i=segments.length-1; i>=0; i--) {
      segments[i] = segments[i].trim();
      if(segments[i].isEmpty) {
        segments.removeAt(i);
      }
    }
    return segments;
  }

  /// Returns a single path string with the specified segments combined.
  static String combineSegments(List<String> segments, {bool leadSlash = true}) {
    String path = "";
    if(segments != null) {
      for(String segment in segments) {
        if(segment != null) {
          segment = segment.trim();
          if(segment.isNotEmpty) {
            path = "$path/$segment";
          }
        }
      }
    }

    path = path.isEmpty ? "/" : path;
    if(!leadSlash) {
      path = path.substring(1);
    }
    return path;
  }
}