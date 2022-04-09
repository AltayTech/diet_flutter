import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:flutter/material.dart';

class BillPaymentProvider extends InheritedWidget {
  final BillPaymentBloc bloc;

  const BillPaymentProvider(this.bloc, {Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static BillPaymentBloc of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<BillPaymentProvider>()!.bloc;
  }
}