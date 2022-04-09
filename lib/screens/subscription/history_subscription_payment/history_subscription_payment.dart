import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/bloc.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/list_history_subscription_payment.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/provider.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class HistorySubscriptionPaymentScreen extends StatefulWidget {
  const HistorySubscriptionPaymentScreen({Key? key}) : super(key: key);

  @override
  _HistorySubscriptionPaymentScreenState createState() =>
      _HistorySubscriptionPaymentScreenState();
}

class _HistorySubscriptionPaymentScreenState
    extends ResourcefulState<HistorySubscriptionPaymentScreen> {
  late HistorySubscriptionPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = HistorySubscriptionPaymentBloc();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return HistorySubscriptionPaymentProvider(bloc, child: body());
  }

  Widget body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.selectPackageToolbar),
        body: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: Column(
              children: [
                historySubscriptionPaymentText(),
                ListHistorySubscriptionPaymentWidget()
              ],
            ),
          ),
        ));
  }

  Widget historySubscriptionPaymentText() {
    return Container(
      width: 90.w,
      margin: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
      padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
      alignment: Alignment.topRight,
      child: Text(intl.historySubscriptionPayment,
          textAlign: TextAlign.start,
          style: typography.caption!.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {}
}
