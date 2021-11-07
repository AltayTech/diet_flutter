import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:flutter/material.dart';
class TicketProvider extends InheritedWidget {
  final TicketBloc bloc;

  const TicketProvider(this.bloc, {Key? key, required Widget child}): super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TicketBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TicketProvider>()!.bloc;
  }
}