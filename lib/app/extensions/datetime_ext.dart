extension DateTimeExt on DateTime {
  String getCurrentDayMonthYearStr() {
    return DateTime.now().toString().split(' ')[0];
  }
}