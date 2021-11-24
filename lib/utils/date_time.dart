// import 'dart:html';

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

  static String gregorianToJalali(String date) {
    List<String> data = date.replaceAll('-', '/').substring(0, 10).split('/');
    Gregorian g = Gregorian(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]));
    final f = g.toJalali().formatter;
    return '${f.yyyy}/${f.mm}/${f.dd}';
  }

  static String dateToNamesOfDay(String date) {
    List<String> data = date.replaceAll('-', '/').substring(0, 10).split('/');
    Gregorian g = Gregorian(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]));
    final f = g.toJalali().formatter;
    return '${f.wN}';
  }

  static String dateToDetail(String date) {
    List<String> data = date.replaceAll('-', ' ').substring(0, 10).split(' ');
    Jalali g = Jalali(int.parse(data[0]), int.parse(data[1]), int.parse(data[2]));
    final f = g.formatter;
    return '${f.d} ${f.mN} ${f.y}';
  }

  static convertToJalali(DateTime date) {
    List<String> data = date.toJalali().toString().substring(7,18).replaceAll(',', '/').split('/');
    if(int.parse(data[1]) < 10)
      data[1] = '0${data[1]}'.replaceAll(' ', '');
    if(int.parse(data[2]) < 10)
      data[2] = '0${data[2]}'.replaceAll(' ', '');
    return '${data[0]}-${data[1]}-${data[2]}';
  }

  static String getTime(String date) {
    var dateSplit = DateTime.parse(date);
    if (dateSplit.isUtc) {
      dateSplit = dateSplit.toLocal();
    }
    return "${numberZero(dateSplit.hour)}:${numberZero(dateSplit.minute)}";
  }

  static String numberZero(int value) {
    if (value < 10) {
      return "0$value";
    } else {
      return "$value";
    }
  }
}

enum Meal {
  breakfast,
  lunch,
  dinner,
}
