class DateFormatter {

  DateFormatter._();

  /// Example: 2020-12-28 16:53
  static String yyyymmddHHMM(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}";
  }
}