import 'package:behandam/screens/psychology/calender_bloc.dart';
import 'package:flutter/material.dart';
class CalendarProvider extends InheritedWidget {
  final CalenderBloc bloc;

  const CalendarProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CalenderBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CalendarProvider>()!.bloc;
  }
}