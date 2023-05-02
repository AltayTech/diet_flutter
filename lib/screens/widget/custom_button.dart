import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class CustomButton extends StatefulWidget {
  CustomButton(this.btnColor, this.textColor, this.txt, this.size, this.press) : super();

  CustomButton.withIcon(this.btnColor, this.textColor, this.txt, this.size, this.icon, this.press)
      : super();

  final Color btnColor;
  Color? textColor;
  final String txt;
  final Size size;
  final Function press;
  Icon? icon;

  // final Icon icon,

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends ResourcefulState<CustomButton> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.icon == null
        ? button(widget.btnColor, widget.txt, widget.size, widget.press, widget.textColor)
        : buttonWithIcon(
            widget.btnColor, widget.txt, widget.size, widget.press, widget.icon!, widget.textColor);
  }

  Widget button(Color btnColor, String txt, Size size, Function press, Color? txtColor) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all<Color>(btnColor),
            fixedSize: MaterialStateProperty.all(size),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            // padding: MaterialStateProperty.all(
            //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        child: Ink(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Container(
              width: size.width,
              height: size.height,
              alignment: Alignment.center,
              child:
                  Text(txt, style: typography.caption!.copyWith(color: txtColor ?? Colors.white)),
            )),
        onPressed: () => press.call());
  }

  Widget buttonWithIcon(
      Color btnColor, String txt, Size size, Function press, Icon icon, Color? textColor) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(btnColor),
            fixedSize: MaterialStateProperty.all(size),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            // padding: MaterialStateProperty.all(
            //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), gradient: AppColors.btnColorsGradient),
            child: Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(txt, style: typography.caption!.copyWith(color: Colors.white)),
                    Space(width: 2.w),
                    icon,
                  ],
                ))),
        onPressed: () => press.call());
  }

  Widget buttonWithCustomColor(
      Color btnColor, String txt, Size size, Function press, Icon icon, Color? txtColor) {
    return ElevatedButton(
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            backgroundColor: MaterialStateProperty.all(btnColor),
            fixedSize: MaterialStateProperty.all(size),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
            // padding: MaterialStateProperty.all(
            //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ))),
        child: Ink(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), gradient: AppColors.btnColorsGradient),
            child: Container(
                width: size.width,
                height: size.height,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(txt, style: typography.caption!.copyWith(color: txtColor ?? Colors.white)),
                    Space(width: 2.w),
                    icon,
                  ],
                ))),
        onPressed: () => press.call());
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
