
import 'package:shamsi_date/shamsi_date.dart';

abstract class DateTimeUtils {
  static DateTime get utcNow {
    return DateTime.now().toUtc();
  }

  static DateTime get todayZeroHour {
    final now = DateTime.now();
    return DateTime.utc(now.year, now.month, now.day);
  }

  static int get timezoneOffset {
    final now = DateTime.now();
    return now.timeZoneOffset.inMinutes;
  }

  static bool get isIranTimezone {
    final jalali = Jalali.now();
    var isDst = jalali.month <= 6;
    if ((jalali.month == 6 && jalali.day == 31) || jalali.month == 1 && jalali.day == 1) {
      isDst = false;
    }
    if (isDst && timezoneOffset == 270) {
      return true;
    } else if (!isDst && timezoneOffset == 210) {
      return true;
    }
    return false;
  }
}

enum Meal {
  breakfast,
  lunch,
  dinner,
}
