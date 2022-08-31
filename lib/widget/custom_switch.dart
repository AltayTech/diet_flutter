import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomSwitch extends StatefulWidget {
  bool isSwitched = false;
  String? title;
  String? lableLeft;
  String? lableRight;
  Color? colorSelected, colorOff;
  Function? function;

  CustomSwitch(
      {Key? key,
      required bool isSwitch,
      required String? title,
      required String? lableLeft,
      required String? lableRight,
      required Color colorSelected,
      required Color colorOff,
      this.function}) {
    this.isSwitched = isSwitch;
    this.title = title;
    this.lableLeft = lableLeft;
    this.lableRight = lableRight;
    this.colorOff = colorOff;
    this.colorSelected = colorSelected;
  }

  @override
  _CustomSwitch createState() => _CustomSwitch(this.isSwitched, this.title, this.lableLeft,
      this.lableRight, this.colorSelected, this.colorOff, this.function);
}

class _CustomSwitch extends ResourcefulState<CustomSwitch> {
  bool isSwitched = false;
  String? title;
  String? lableLeft;
  String? lableRight;
  Color? colorSelected, colorOff;
  Function? function;

  _CustomSwitch(bool isSwitch, String? title, String? lableLeft, String? lableRight,
      Color? colorSelected, Color? colorOff, Function? function) {
    this.isSwitched = isSwitch;
    this.title = title;
    this.lableLeft = lableLeft;
    this.lableRight = lableRight;
    this.colorOff = colorOff;
    this.colorSelected = colorSelected;
    this.function = function;
  }

//Color(0xff62D0C5)
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
        width: double.maxFinite,
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: Text(title!, textAlign: TextAlign.right, style: typography.caption),
            ),
            isSwitched
                ? Expanded(
                    flex: 0,
                    child: Text(lableLeft!,
                        textAlign: TextAlign.right,
                        style: typography.caption!.copyWith(color: colorSelected, fontSize: 10.sp)),
                  )
                : Container(),
            Expanded(
              flex: 0,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Switch(
                  value: isSwitched,
                  onChanged: (bool value) {
                    setState(() {
                      isSwitched = value;
                      function!(value);
                    });
                  },
                  activeTrackColor: AppColors.priceGreenColor,
                  // inactiveThumbImage: AssetImage("assets/ellipse.png"),
                  inactiveThumbColor: AppColors.grey,
                  activeColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  inactiveTrackColor: Colors.grey,
                   activeThumbImage: AssetImage("assets/images/ellipse.png"),
                  //  trackColor: CustomColors.tabSelected,
                ),
              ),
            ),
            Expanded(
              flex: 0,
              child: Text(lableRight!,
                  textAlign: TextAlign.left,
                  style: typography.caption!.copyWith(color: Colors.grey, fontSize: 10.sp)),
            ),
          ],
        ));
  }
}
