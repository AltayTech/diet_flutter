import 'package:behandam/screens/status/bloc.dart';
import 'package:flutter/material.dart';

class StatusProvider extends InheritedWidget {
  final StatusBloc bloc;

  const StatusProvider(this.bloc, {Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static StatusBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<StatusProvider>()!.bloc;
  }
}
