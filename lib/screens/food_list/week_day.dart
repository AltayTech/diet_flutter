import 'package:shamsi_date/shamsi_date.dart';

class WeekDay{
  WeekDay({required this.gregorianDate, required this.jalaliDate, this.isSelected});

  final DateTime gregorianDate;
  final Jalali jalaliDate;
  bool? isSelected;
}