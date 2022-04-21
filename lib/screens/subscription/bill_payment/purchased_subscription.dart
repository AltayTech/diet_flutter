import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/subscription/card_package.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class PurchasedSubscriptionWidget extends StatefulWidget {
  PurchasedSubscriptionWidget({Key? key}) : super(key: key);

  @override
  State createState() => _PurchasedSubscriptionWidget();
}

class _PurchasedSubscriptionWidget extends ResourcefulState<PurchasedSubscriptionWidget> {
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
    return Container(
        width: 100.w,
        decoration: AppDecorations.boxSmall.copyWith(
          color: Colors.white,
        ),
        margin: EdgeInsets.only(top: 4.w, left: 4.w, right: 4.w),
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                textDirection: context.textDirectionOfLocale,
                children: [
                  Space(
                    width: 2.w,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w, right: 6.w,top: 1.h,bottom: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          intl.purchasedSubscription,
                          style: typography.subtitle1!
                              .copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Space(
                width: 2.w,
              ),
              CardPackage(bloc.packageItem!, false)
            ]));
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
