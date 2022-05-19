import 'package:behandam/screens/regime/package/package_bloc.dart';
import 'package:behandam/screens/subscription/select_package/bloc.dart';
import 'package:flutter/material.dart';

class SelectPackageSubscriptionProvider extends InheritedWidget {
  final SelectPackageSubscriptionBloc bloc;

  const SelectPackageSubscriptionProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static SelectPackageSubscriptionBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<SelectPackageSubscriptionProvider>()!.bloc;
  }
}
