import 'package:flutter/material.dart';
import 'lgnReg_bloc.dart';
class HomeProvider extends InheritedWidget {
  final LoginRegisterBloc bloc;

  const HomeProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static LoginRegisterBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeProvider>()!.bloc;
  }
}