import 'package:flutter/material.dart';
import 'regime_bloc.dart';

class RegimeProvider extends InheritedWidget {
  final RegimeBloc bloc;

  const RegimeProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RegimeBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RegimeProvider>()!.bloc;
  }
}