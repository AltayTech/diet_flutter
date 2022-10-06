import 'dart:async';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/payment/bloc.dart';
import 'package:behandam/screens/payment/provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class CardInfoWidget extends StatefulWidget {
  const CardInfoWidget({Key? key}) : super(key: key);

  @override
  State<CardInfoWidget> createState() => _CardInfoWidgetState();
}

class _CardInfoWidgetState extends ResourcefulState<CardInfoWidget> {
  late PaymentBloc bloc;

  TextEditingController _cardOwnerNameController = TextEditingController();
  TextEditingController _cardNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _cardOwnerNameController.text = '';
    _cardNumberController.text = '';
  }

  @override
  void dispose() {
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
                    typography.overline!.copyWith(color: AppColors.penColor),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  style: typography.overline!.copyWith(color: AppColors.penColor),
                  onTap: () {
                    // fix bug click on end of text on rtl
                    if (_cardOwnerNameController.selection ==
                        TextSelection.fromPosition(TextPosition(
                            offset: _cardOwnerNameController.text.length - 1))) {
                      _cardOwnerNameController.selection = TextSelection.fromPosition(
                          TextPosition(offset: _cardOwnerNameController.text.length));
                    }
                  },
                  onChanged: (val) {
                    bloc.invoice!.cardOwner = val;
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
                  child: Directionality(
                      textDirection: context.textDirectionOfLocaleInversed,
                      child: cardLastNumbers(
                        widthSpace: 80.w,
                        context: context,
                        textController: _cardNumberController,
                        onDone: (val) {
                          bloc.invoice!.cardNum = val.toString().toEnglishDigit();
                        },
                      ))),
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
