import 'package:behandam/screens/regime/package/package_bloc.dart';
import 'package:flutter/material.dart';

class PackageProvider extends InheritedWidget {
  final PackageBloc bloc;

  const PackageProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PackageBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PackageProvider>()!.bloc;
  }
}
