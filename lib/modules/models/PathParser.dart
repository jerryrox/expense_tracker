/// Class which parses a given string into a list of path segments.
/// Uri.parse does not work when there is a column in the path.
/// Therefore, this logic had to be built manually.
class PathParser {

  PathParser._();

  /// Returns the list of path segments for the specified path.
  static List<String> parse(String path) {
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
}