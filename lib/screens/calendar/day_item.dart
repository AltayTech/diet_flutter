import 'package:shamsi_date/shamsi_date.dart';

class DayItem {
  final Jalali jalali;
  final Gregorian gregorian;
  List<DayType?> types;

  DayItem({
    required this.jalali,
    required this.gregorian,
    required this.types,
  });
}

enum DayType {
  usual,
  fade,
  termStart,
  termEnd,
  menuStart,
  menuEnd,
  newList,
  visit,
  newTerm,
  menu,
  menuAlert,
  visitAlert,
}
