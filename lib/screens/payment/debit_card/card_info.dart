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

class CardInfoWidget extends StatefulWidget {
  const CardInfoWidget({Key? key}) : super(key: key);

  @override
  State<CardInfoWidget> createState() => _CardInfoWidgetState();
}

class _CardInfoWidgetState extends ResourcefulState<CardInfoWidget> {
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

    return cardInfoBox();
  }

  Widget cardInfoBox() {
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
                intl.enterDataAfterPayment,
                style: typography.caption?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              ),
              Space(height: 2.h),
              Container(
                margin: EdgeInsets.only(right: 2.w, left: 2.w),
                decoration: AppDecorations.boxSmall.copyWith(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.grey,
                ),
                child: TextField(
                  controller: _cardOwnerNameController,
                  textDirection: context.textDirectionOfLocale,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: intl.cardOwnerName,
                    hintStyle:
                        TextStyle(color: AppColors.penColor, fontSize: 10.sp),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  style: TextStyle(color: AppColors.penColor, fontSize: 10.sp),
                  onChanged: (txt) {
                    //_password = txt;
                  },
                ),
              ),
              Space(height: 4.h),
              Text(
                intl.lastFourDigitsCardNumber,
                style: typography.caption?.copyWith(
                  color: Colors.black,
                ),
                textAlign: TextAlign.start,
                softWrap: true,
              ),
              Space(height: 2.h),
              Container(
                  margin: EdgeInsets.only(right: 2.w, left: 2.w),
                  child: cardLastNumbers(widthSpace: 80.w, context: context)),
              Space(height: 2.h),
            ],
          ),
        ),
      ],
    );
  }

  Widget cardLastNumbers(
      {StreamController? errorController,
      TextEditingController? textController,
      required double widthSpace,
      Function? onDone,
      Color? color,
      required BuildContext context,
      double? height}) {
    return PinCodeTextField(
      appContext: context,
      pastedTextStyle: TextStyle(
        color: AppColors.grey,
        fontWeight: FontWeight.bold,
      ),
      length: 4,
      obscureText: false,
      obscuringCharacter: '*',
      animationType: AnimationType.fade,
      validator: (v) {
        return null;
      },
      pinTheme: PinTheme(
          shape: PinCodeFieldShape.box,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          fieldHeight: height,
          fieldWidth: widthSpace / 5,
          activeColor: AppColors.grey,
          disabledColor: AppColors.grey,
          inactiveColor: AppColors.grey,
          selectedColor: AppColors.grey,
          selectedFillColor: AppColors.grey,
          activeFillColor: AppColors.grey,
          inactiveFillColor: AppColors.grey),
      cursorColor: Colors.black,
      animationDuration: Duration(milliseconds: 300),
      textStyle: TextStyle(
        fontSize: 20,
        height: 1.6,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: color,
      enableActiveFill: true,
      errorAnimationController:
          errorController as StreamController<ErrorAnimationType>?,
      controller: textController,
      keyboardType: TextInputType.number,
      /* onCompleted: (v) {
      textController!.text = v;
    },*/
      // onTap: () {
      //   Fimber.d("Pressed");
      // },
      onChanged: (value) {
        onDone!(value);
        textController!.selection = TextSelection.fromPosition(
            TextPosition(offset: textController.text.length));
        // setState(() {
        //   currentText = value;
        // });
      },
      beforeTextPaste: (text) {
        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
        //but you can show anything you want here, like your pop up saying wrong paste format or etc
        return true;
      },
//    borderWidth: widthSpace * 0.005,
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
