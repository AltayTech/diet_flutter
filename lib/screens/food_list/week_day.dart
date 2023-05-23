import 'package:shamsi_date/shamsi_date.dart';

class WeekDay{
  WeekDay({required this.gregorianDate, required this.jalaliDate, this.isSelected,this.clickable});

  final DateTime gregorianDate;
  final Gregorian jalaliDate;

  bool? isSelected;
  bool? clickable;
}