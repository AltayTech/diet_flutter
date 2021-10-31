import 'package:flutter/material.dart';
import 'dart:async';
import 'package:pin_code_fields/pin_code_fields.dart';

Widget pinCodeInput(
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
      color: Color.fromRGBO(154, 154, 154, 1),
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
        borderRadius: BorderRadius.all(Radius.circular(5)),
        borderWidth: 0.7,
        fieldHeight: height,
        fieldWidth: widthSpace / 5,
        activeColor: Colors.white,
        disabledColor: Colors.grey[500],
        inactiveColor: Colors.grey[500],
        selectedColor: Colors.grey[500],
        selectedFillColor: Colors.white,
        activeFillColor: Colors.white,
        inactiveFillColor: Colors.white),
    cursorColor: Colors.grey[500],
    animationDuration: Duration(milliseconds: 300),
    textStyle: TextStyle(
      fontSize: 20,
      height: 1.6,
      color: Color.fromRGBO(154, 154, 154, 1),
      fontWeight: FontWeight.bold,
    ),
    backgroundColor: color,
    enableActiveFill: true,
    errorAnimationController: errorController as StreamController<ErrorAnimationType>?,
    controller: textController,
    boxShadows: [
      BoxShadow(
        offset: Offset(0, 1),
        color: Colors.black12,
        blurRadius: 10,
      )
    ],
    keyboardType: TextInputType.number,
    onCompleted: (v) {
      textController!.text = v;
    },
    // onTap: () {
    //   Fimber.d("Pressed");
    // },
    onChanged: (value) {
      onDone!(value);
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