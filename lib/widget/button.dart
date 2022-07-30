import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

Widget button(Color btnColor, String txt, Size size, Function press) {
  return ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: MaterialStateProperty.all(btnColor),
          fixedSize: MaterialStateProperty.all(size),
          padding: MaterialStateProperty.all(EdgeInsets.zero),
          // padding: MaterialStateProperty.all(
          //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ))),
      child: Ink(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              gradient: AppColors.btnColorsGradient),
          child: Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child: Text(txt, style: TextStyle(fontSize: 20.0)))),
      onPressed: () => press.call());
}
