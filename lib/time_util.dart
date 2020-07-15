import 'package:intl/intl.dart';

class TimeFormat {
  static const dateFormatYMD = "yyyyMMdd";
  static const dateFormatFull = "yyyy-MM-dd kk:mm:ss";
}

class TimeUtil {
  /// get date format with year mouth day
  static String getDateFormatYMD() {
    final now = DateTime.now();
    return DateFormat(TimeFormat.dateFormatYMD).format(now);
  }

  /// get date format full with millisecond
  static String getDateFormatFullWithMillisecond() {
    final now = DateTime.now();
    return "${DateFormat(TimeFormat.dateFormatFull).format(now)} ${now.millisecond % 1000}";
  }
}
