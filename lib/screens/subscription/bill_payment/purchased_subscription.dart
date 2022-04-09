import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class PurchasedSubscriptionWidget extends StatefulWidget {
  PurchasedSubscriptionWidget({Key? key}) : super(key: key);

  @override
  State createState() => _PurchasedSubscriptionWidget();
}

class _PurchasedSubscriptionWidget
    extends ResourcefulState<PurchasedSubscriptionWidget> {
  late BillPaymentBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = BillPaymentProvider.of(context);

    return purchasedSubscriptionWidget();
  }

  Widget purchasedSubscriptionWidget() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        textDirection: context.textDirectionOfLocale,
        children: [
          Container(
            width: 80.w,
            decoration: AppDecorations.boxSmall.copyWith(
              color: Colors.white,
            ),
            margin: EdgeInsets.only(top: 2.h, left: 4.w, right: 4.w),
            padding:
                EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: context.textDirectionOfLocale,
              children: [
                Space(
                  width: 2.w,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        intl.purchasedSubscription,
                        style: typography.subtitle1!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 12.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ]);
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
