import 'package:behandam/screens/regime/payment/payment_bloc.dart';
import 'package:flutter/material.dart';

class PaymentProvider extends InheritedWidget {
  final PaymentBloc bloc;

  const PaymentProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static PaymentBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<PaymentProvider>()!.bloc;
  }
}
