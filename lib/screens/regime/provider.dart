import 'package:flutter/material.dart';
import 'regime_bloc.dart';

class HomeProvider extends InheritedWidget {
  final RegimeBloc bloc;

  const HomeProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static RegimeBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeProvider>()!.bloc;
  }
}