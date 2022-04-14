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

  TextEditingController _cardOwnerNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    _cardOwnerNameController.dispose();
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
                    stream: bloc.selectedDate,
                    builder: (context, selectedDate) {
                      if (selectedDate.hasData)
                        return Container(
                          width: double.maxFinite,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: paymentDateItem(
                                      selectedDate.data! == PaymentDate.today,
                                      PaymentDate.today),
                                ),
                                Space(width: 3.w),
                                Expanded(
                                  child: paymentDateItem(
                                      selectedDate.data! ==
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
      onTap: () => bloc.SetSelectedDate = date,
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
                                date == PaymentDate.today
                                    ? intl.todayPay
                                    : intl.newDate,
                                softWrap: false,
                                style: typography.caption!.copyWith(
                                    color: isSelected
                                        ? AppColors.priceColor
                                        : Colors.black,
                                fontSize: 10.sp),
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
