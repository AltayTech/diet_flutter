import 'package:behandam/screens/subscription/history_subscription_payment/bloc.dart';
import 'package:flutter/material.dart';

class HistorySubscriptionPaymentProvider extends InheritedWidget {
  final HistorySubscriptionPaymentBloc bloc;

  const HistorySubscriptionPaymentProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static HistorySubscriptionPaymentBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<HistorySubscriptionPaymentProvider>()!.bloc;
  }
}