import 'dart:async';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:share_plus/share_plus.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class PaymentDateWidget extends StatefulWidget {
  const PaymentDateWidget({Key? key}) : super(key: key);

  @override
  State<PaymentDateWidget> createState() => _PaymentDateWidgetState();
}

class _PaymentDateWidgetState extends ResourcefulState<PaymentDateWidget> {
  late PaymentBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = PaymentProvider.of(context);

    return paymentDateBox();
  }

  Widget paymentDateBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 2.h),
          padding: EdgeInsets.all(8),
          decoration: AppDecorations.boxSmall.copyWith(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Column(
            children: [
              Space(height: 2.h),
              Text(
                intl.paymentDate,
                style: typography.caption?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              ),
              Space(height: 2.h),
              Container(
                margin: EdgeInsets.only(right: 2.w, left: 2.w),
                child: StreamBuilder<PaymentDate?>(
                    stream: bloc.selectedDateType,
                    builder: (context, selectedDateType) {
                      if (selectedDateType.hasData)
                        return Container(
                          width: double.maxFinite,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: paymentDateItem(
                                      selectedDateType.data! ==
                                          PaymentDate.today,
                                      PaymentDate.today),
                                ),
                                Space(width: 3.w),
                                Expanded(
                                  child: paymentDateItem(
                                      selectedDateType.data! ==
                                          PaymentDate.customDate,
                                      PaymentDate.customDate),
                                )
                              ]),
                        );
                      return Container();
                    }),
              ),
              Space(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget paymentDateItem(bool isSelected, PaymentDate date) {
    return InkWell(
      onTap: () {
        bloc.setSelectedDateType = date;

        if (date == PaymentDate.today)
          bloc.setSelectedDate = DateTimeUtils.formatTodayDate();

        if (date == PaymentDate.customDate) selectDate();
      },
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        margin: EdgeInsets.only(right: 2.w),
        decoration: BoxDecoration(
          color: Colors.white,
          border: isSelected
              ? Border.all(color: AppColors.priceColor)
              : Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(minHeight: 8.h),
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  ImageUtils.fromLocal(
                    isSelected
                        ? 'assets/images/bill/check.svg'
                        : 'assets/images/bill/not_select.svg',
                    width: 2.5.w,
                    height: 2.5.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 2.w),
                    child: Text(
                      date == PaymentDate.today ? intl.todayPay : intl.newDate,
                      softWrap: false,
                      style: typography.caption!.copyWith(
                          color: isSelected
                              ? AppColors.priceColor
                              : AppColors.greyDate,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
            ),
            Space(height: 1.h),
            Container(
              alignment: Alignment.center,
              width: double.maxFinite,
              padding: EdgeInsets.symmetric(horizontal: 16),
              margin: EdgeInsets.only(top: 10),
              child: date == PaymentDate.today
                  ? Text(
                      DateTimeUtils.formatTodayDate(),
                      softWrap: false,
                      style: typography.caption!.copyWith(
                          color: AppColors.greyDate,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w400),
                    )
                  : StreamBuilder<String>(
                      stream: bloc.selectedDate,
                      builder: (context, selectedDate) {
                        return Text(
                          (selectedDate.hasData && date == PaymentDate.customDate
                              ? DateTimeUtils.formatCustomDate(
                                  selectedDate.requireData)
                              : intl.selectNewDate),
                          softWrap: false,
                          style: typography.caption!.copyWith(
                              color: AppColors.redDate,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400),
                        );
                      }),
            ),
            Space(height: 1.h),
          ],
        ),
      ),
    );
  }

  void selectDate() {
    DialogUtils.showBottomSheetPage(
        context: context,
        child: SingleChildScrollView(
          child: Container(
            height: 60.h,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    closeDialog(),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Center(
                            child: Text(
                              intl.selectPaymentDate,
                              softWrap: false,
                              style: typography.caption!.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ))
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      intl.enterPaymentDate,
                      softWrap: false,
                      style: typography.caption!
                          .copyWith(color: Colors.black, fontSize: 10.sp),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: CustomDate(
                      function: (value) {
                        debugPrint('date selected = > $value');

                        bloc.setDate = value;
                      },
                      datetime: DateTime.parse(Jalali.now()
                              .toDateTime()
                              .toString()
                              .substring(0, 10))
                          .toString()
                          .substring(0, 10),
                      maxYear: Jalali.now().year,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: SubmitButton(
                    label: intl.submitDate,
                    onTap: () {
                      if (bloc.date != null) {
                        bloc.setSelectedDate = bloc.date!;

                        bloc.invoice!.payedAt =
                            DateTimeUtils.jalaliToGregorian(bloc.date!);

                        debugPrint(
                            'date selected = > ${bloc.invoice!.payedAt}');

                        Navigator.of(context).pop();
                      }
                    },
                    size: Size(80.w, 6.h),
                  )),
                )
              ],
            ),
          ),
        ));
  }

  Widget closeDialog() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topRight,
        child: Container(
          decoration: AppDecorations.boxSmall.copyWith(
            color: AppColors.primary.withOpacity(0.4),
          ),
          padding: EdgeInsets.all(1.w),
          child: Icon(
            Icons.close,
            size: 6.w,
            color: AppColors.onPrimary,
          ),
        ),
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
