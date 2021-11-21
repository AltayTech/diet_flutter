import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:flutter/material.dart';

class SicknessProvider extends InheritedWidget {
  final SicknessBloc bloc;

  const SicknessProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SicknessBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SicknessProvider>()!.bloc;
  }
}
