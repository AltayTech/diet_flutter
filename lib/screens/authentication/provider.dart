import 'package:flutter/material.dart';
import 'authentication_bloc.dart';
class HomeProvider extends InheritedWidget {
  final AuthenticationBloc bloc;

  const HomeProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthenticationBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HomeProvider>()!.bloc;
  }
}