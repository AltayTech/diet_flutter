import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/bloc.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class ListHistorySubscriptionPaymentWidget extends StatefulWidget {
  ListHistorySubscriptionPaymentWidget({Key? key}) : super(key: key);

  @override
  State createState() => _ListHistorySubscriptionPaymentWidget();
}

class _ListHistorySubscriptionPaymentWidget
    extends ResourcefulState<ListHistorySubscriptionPaymentWidget> {
  late HistorySubscriptionPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = HistorySubscriptionPaymentProvider.of(context);

    return listHistorySubscriptionPaymentWidget();
  }

  Widget listHistorySubscriptionPaymentWidget() {
    return ListView.builder(
      itemCount: 2,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.only(bottom: 8, top: 8),
      itemBuilder: (context, i) {
        return historySubscriptionPaymentWidgetItem();
      },
    );
  }

  Widget historySubscriptionPaymentWidgetItem() {
    return Container(
      width: double.maxFinite,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      constraints: BoxConstraints(minHeight: 8.h),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  'خرید اشتراک 30 روزه + ورزش',
                  softWrap: false,
                  style: typography.caption!
                      .copyWith(color: Colors.black, fontSize: 10.sp),
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(top: 3.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'تاریخ درخواست:',
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography.caption!
                        .copyWith(color: Colors.black, fontSize: 8.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    '08:12 1400/03/04',
                    softWrap: false,
                    textAlign: TextAlign.end,
                    style: typography.caption!
                        .copyWith(color: Colors.black, fontSize: 8.sp),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            margin: EdgeInsets.only(top: 1.h, bottom: 2.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    'مبلغ پرداختی:',
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography.caption!
                        .copyWith(color: Colors.black, fontSize: 8.sp),
                  ),
                ),
                Expanded(
                    child: Text.rich(
                        TextSpan(
                            text: '80.000',
                            style: typography.caption!
                                .copyWith(color: Colors.black),
                            children: <InlineSpan>[
                              TextSpan(
                                text: 'تومان',
                                style: typography.caption!.copyWith(
                                    color: Colors.black, fontSize: 8.sp),
                              )
                            ]),
                        textAlign: TextAlign.end))
              ],
            ),
          )
        ],
      ),
    );
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
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}