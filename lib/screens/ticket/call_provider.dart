import 'package:behandam/screens/ticket/call_bloc.dart';
import 'package:flutter/material.dart';

class CallProvider extends InheritedWidget {
  final CallBloc bloc;

  const CallProvider(this.bloc, {Key? key, required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static CallBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<CallProvider>()!.bloc;
  }
}
