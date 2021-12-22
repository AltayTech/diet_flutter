import 'package:flutter/material.dart';
import 'bloc.dart';

class FoodListProvider extends InheritedWidget {
  FoodListProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  final FoodListBloc bloc;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FoodListBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<FoodListProvider>()!.bloc;
  }
}