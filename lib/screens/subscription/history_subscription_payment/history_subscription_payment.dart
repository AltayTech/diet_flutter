import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/bloc.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/list_history_subscription_payment.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class HistorySubscriptionPaymentScreen extends StatefulWidget {
  const HistorySubscriptionPaymentScreen({Key? key}) : super(key: key);

  @override
  _HistorySubscriptionPaymentScreenState createState() => _HistorySubscriptionPaymentScreenState();
}

class _HistorySubscriptionPaymentScreenState
    extends ResourcefulState<HistorySubscriptionPaymentScreen> {
  late HistorySubscriptionPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    bloc = HistorySubscriptionPaymentBloc();
    bloc.getUserSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return HistorySubscriptionPaymentProvider(bloc, child: body());
  }

  Widget body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.showHistorySubscription),
        body: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: Column(
              children: [
                historySubscriptionPaymentText(),
                StreamBuilder<SubscriptionPendingData?>(
                  stream: bloc.subscriptionPending,
                  builder: (context, subscriptionPending) {
                    if (subscriptionPending.hasData && subscriptionPending.data != null)
                      return Container(
                        width: 90.w,
                        margin: EdgeInsets.only(top: 8),
                        alignment: Alignment.topRight,
                        child: pendingSubscriptionBox(subscriptionPending.requireData!),
                      );
                    else
                      return EmptyBox();
                  },
                ),
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

  Widget pendingSubscriptionBox(SubscriptionPendingData subscriptionPendingData) {
    return DottedBorder(
      radius: Radius.circular(20),
      borderType: BorderType.RRect,
      color: AppColors.primary,
      strokeCap: StrokeCap.round,
      dashPattern: [6, 3, 2, 3],
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
            width: double.maxFinite,
            color: AppColors.primary.withOpacity(0.2),
            alignment: Alignment.topCenter,
            constraints: BoxConstraints(minHeight: 8.h),
            padding: EdgeInsets.only(
              bottom: 1.h,
              top: 1.h,
              left: 5.w,
              right: 5.w,
            ),
            child: descriptionStatusPaymentSubscription(
                subscriptionPendingData: subscriptionPendingData)),
      ),
    );
  }

  Widget descriptionStatusPaymentSubscription(
      {required SubscriptionPendingData subscriptionPendingData}) {
    return Text(
      intl.descriptionStatusPaymentSubscription(
          subscriptionPendingData.packageName,
          '${DateTimeUtils.formatCustomDate(subscriptionPendingData.createdAt.split("T")[0])}',
          subscriptionPendingData.termDays),
      softWrap: true,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.overline!.copyWith(fontWeight: FontWeight.w700),
    );
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
  }

  @override
  void onRetryLoadingPage() {
    bloc.onRetryLoadingPage();
  }
}
