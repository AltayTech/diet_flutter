import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/screens/subscription/bill_payment/bloc.dart';
import 'package:behandam/screens/subscription/bill_payment/provider.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class PaymentTypeWidget extends StatefulWidget {
  PaymentTypeWidget({Key? key}) : super(key: key);

  @override
  State createState() => _PaymentTypeWidget();
}

class _PaymentTypeWidget extends ResourcefulState<PaymentTypeWidget> {
  late BillPaymentBloc bloc;

  late Package packageItem;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = BillPaymentProvider.of(context);

    packageItem = bloc.packageItemNew!;

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
              color: Color(0xfff5f5f5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              textDirection: context.textDirectionOfLocale,
              children: [
                Space(
                  width: 2.w,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StreamBuilder<bool>(
                            initialData: false,
                            stream: bloc.usedDiscount,
                            builder: (context, usedDiscount) {
                              if ((bloc.packageItem?.price?.totalPrice == null ||
                                  bloc.packageItem!.price!.totalPrice! > 0))
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(top: 2.h, bottom: 2.h),
                                      child: Text(
                                        intl.paymentType,
                                        style: typography.subtitle1!
                                            .copyWith(fontWeight: FontWeight.bold, fontSize: 12.sp),
                                      ),
                                    ),
                                    Space(height: 1.h),
                                    Container(
                                      child: StreamBuilder<PaymentType?>(
                                          stream: bloc.selectedPayment,
                                          builder: (context, selectedPayment) {
                                            if (selectedPayment.hasData)
                                              return Container(
                                                width: double.maxFinite,
                                                child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: CheckBoxApp(
                                                          title: intl.cardToCard,
                                                          isSelected: selectedPayment.data! ==
                                                              PaymentType.cardToCard,
                                                          onTap: () {
                                                            bloc.onPaymentTap =
                                                                PaymentType.cardToCard;
                                                          },
                                                          maxHeight: 8.h,
                                                          isBorder: true,
                                                          iconSelectType: IconSelectType.Radio,
                                                        ),
                                                      ),
                                                      Space(width: 3.w),
                                                      Expanded(
                                                        child: CheckBoxApp(
                                                          title: intl.cardToCard,
                                                          isSelected: selectedPayment.data! ==
                                                              PaymentType.online,
                                                          onTap: () {
                                                            bloc.onPaymentTap =
                                                                PaymentType.online;
                                                          },
                                                          maxHeight: 8.h,
                                                          isBorder: true,
                                                          iconSelectType: IconSelectType.Radio,
                                                        )
                                                      )
                                                    ]),
                                              );
                                            return Container();
                                          }),
                                    )
                                  ],
                                );
                              else
                                return EmptyBox();
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
                flex: 2,
                child: Text(
                  packageItem.name!,
                  softWrap: true,
                  textAlign: TextAlign.start,
                  style: typography.caption!
                      .copyWith(color: AppColors.priceGreyColor, fontSize: 10.sp),
                ),
              ),
              Expanded(
                flex: 1,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  softWrap: true,
                  text: TextSpan(
                    text: '${packageItem.price} ',
                    children: [
                      TextSpan(
                        text: intl.toman,
                        style: typography.overline!
                            .copyWith(color: AppColors.priceGreyColor, fontSize: 9.sp),
                      ),
                    ],
                    style: typography.caption!
                        .copyWith(color: AppColors.priceGreyColor, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
          if (packageItem.totalPrice == null &&
              packageItem.finalPrice != packageItem.price &&
              packageItem.finalPrice != 0 &&
              packageItem.price != 0)
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
                      style: typography.caption!
                          .copyWith(color: AppColors.priceDiscountColor, fontSize: 10.sp),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${packageItem.price! - packageItem.finalPrice!} ${intl.toman}',
                      softWrap: false,
                      textAlign: TextAlign.end,
                      style: typography.caption!.copyWith(color: AppColors.priceDiscountColor),
                    ),
                  ),
                ],
              ),
            ),
          StreamBuilder<bool>(
              initialData: false,
              stream: bloc.usedDiscount,
              builder: (context, usedDiscount) {
                if (usedDiscount.requireData)
                  return Container(
                    margin: EdgeInsets.only(top: 1.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            intl.discountForYou,
                            softWrap: false,
                            textAlign: TextAlign.start,
                            style: typography.caption!
                                .copyWith(color: AppColors.priceDiscountColor, fontSize: 10.sp),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${bloc.discountInfo!.discount} ${intl.toman}',
                            softWrap: false,
                            textAlign: TextAlign.end,
                            style:
                                typography.caption!.copyWith(color: AppColors.priceDiscountColor),
                          ),
                        ),
                      ],
                    ),
                  );
                return Container();
              }),
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
                    style: typography.caption!.copyWith(color: Colors.black),
                  ),
                ),
                StreamBuilder<bool>(
                    initialData: false,
                    stream: bloc.usedDiscount,
                    builder: (context, usedDiscount) {
                      return Expanded(
                        child: Text(
                          usedDiscount.requireData
                              ? packageItem.totalPrice != 0 && packageItem.totalPrice != null
                                  ? '${packageItem.totalPrice} ${intl.toman}'
                                  : intl.free
                              : '${packageItem.finalPrice} ${intl.toman}',
                          softWrap: false,
                          textAlign: TextAlign.end,
                          style: typography.caption!.copyWith(color: AppColors.priceGreenColor),
                        ),
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
