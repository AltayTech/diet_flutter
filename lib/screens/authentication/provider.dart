import 'package:flutter/material.dart';
import 'authentication_bloc.dart';
class AuthenticationProvider extends InheritedWidget {
  final AuthenticationBloc bloc;

  const AuthenticationProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthenticationBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AuthenticationProvider>()!.bloc;
  }
}