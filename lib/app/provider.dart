import 'package:behandam/app/bloc.dart';
import 'package:flutter/material.dart';


class AppProvider extends InheritedWidget {
  final AppBloc bloc;

  AppProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AppBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppProvider>()!.bloc;
  }
}