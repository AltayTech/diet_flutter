import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class PaymentTypeWidget extends StatefulWidget {
  PaymentTypeWidget({Key? key}) : super(key: key);

  @override
  State createState() => _PaymentTypeWidget();
}

class _PaymentTypeWidget extends ResourcefulState<PaymentTypeWidget> {
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

    return paymentTypeWidget();
  }

  Widget paymentTypeWidget() {
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
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                          child: Text(
                            intl.paymentType,
                            style: typography.subtitle1!.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),
                        ),
                        Space(height: 1.h),
                        StreamBuilder<PaymentType?>(
                            stream: bloc.selectedPayment,
                            builder: (context, selectedPayment) {
                              if (selectedPayment.hasData)
                                return Container(
                                  width: double.maxFinite,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: paymentItem(
                                              selectedPayment.data! ==
                                                  PaymentType.cardToCard,
                                              PaymentType.cardToCard),
                                        ),
                                        Space(width: 3.w),
                                        Expanded(
                                          child: paymentItem(
                                              selectedPayment.data! ==
                                                  PaymentType.online,
                                              PaymentType.online),
                                        )
                                      ]),
                                );
                              return Container();
                            }),
                        showSubscriptionInfo()
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ]);
  }

  Widget paymentItem(bool isSelected, PaymentType type) {
    return InkWell(
      onTap: () => bloc.onPaymentTap = type,
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border: isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(minHeight: 8.h),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 0,
                child: ImageUtils.fromLocal(
                  isSelected
                      ? 'assets/images/bill/check.svg'
                      : 'assets/images/bill/not_select.svg',
                  width: 3.w,
                  height: 3.h,
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  alignment: Alignment.center,
                  width: double.maxFinite,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*itemMonth(package),*/
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                type == PaymentType.online
                                    ? intl.online
                                    : intl.cardToCard,
                                softWrap: false,
                                style: typography.caption!.copyWith(
                                    color: isSelected
                                        ? AppColors.priceColor
                                        : Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget showSubscriptionInfo() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(top: 3.h, bottom: 3.h),
      padding: EdgeInsets.all(4.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  'پکیج سه ماه کاهش وزن',
                  softWrap: false,
                  textAlign: TextAlign.start,
                  style: typography.caption!.copyWith(
                      color: AppColors.priceGreyColor, fontSize: 10.sp),
                ),
              ),
              Expanded(
                child: Text(
                 '330.000 تومان',
                  softWrap: false,
                  textAlign: TextAlign.end,
                  style: typography.caption!.copyWith(
                      color: AppColors.priceGreyColor),
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    intl.discount,
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography.caption!.copyWith(
                        color: AppColors.priceDiscountColor, fontSize: 10.sp),
                  ),
                ),
                Expanded(
                  child: Text(
                    '30.000 تومان',
                    softWrap: false,
                    textAlign: TextAlign.end,
                    style: typography.caption!.copyWith(
                        color: AppColors.priceDiscountColor),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: EdgeInsets.only(top: 1.h),
            padding: EdgeInsets.all(3.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    intl.totalPrice,
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography.caption!.copyWith(
                        color: Colors.black),
                  ),
                ),
                Expanded(
                  child: Text(
                    '300.000 تومان',
                    softWrap: false,
                    textAlign: TextAlign.end,
                    style: typography.caption!.copyWith(
                        color: AppColors.priceGreenColor),
                  ),
                ),
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
