import 'package:flutter/material.dart';
import 'profile_bloc.dart';
class ProfileProvider extends InheritedWidget {
  final ProfileBloc bloc;

  const ProfileProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static ProfileBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ProfileProvider>()!.bloc;
  }
}