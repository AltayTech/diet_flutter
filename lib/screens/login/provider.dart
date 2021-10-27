import 'package:flutter/material.dart';
import 'login-bloc.dart';
class HomeProvider extends InheritedWidget {
  final LoginBloc bloc;

  const HomeProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeProvider>()!.bloc;
  }
}