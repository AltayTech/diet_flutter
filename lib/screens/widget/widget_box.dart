import 'package:behandam/app/app.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:url_launcher/url_launcher.dart';

void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusManager.instance.primaryFocus?.requestFocus(nextFocus);
}

const inputDecoration = InputDecoration(
  filled: true,
  fillColor: Color.fromARGB(255, 245, 245, 245),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 164, 164, 164),
      width: 1.0,
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 164, 164, 164),
      width: 1.0,
    ),
  ),
  labelText: '',
  labelStyle: TextStyle(
    color: Color.fromARGB(255, 195, 194, 194),
    fontSize: 18.0,
    letterSpacing: -0.5,
  ),
  // contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
  errorStyle: TextStyle(
    color: Color.fromARGB(255, 255, 87, 87),
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 255, 87, 87),
      width: 1.0,
    ),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Color.fromARGB(255, 255, 87, 87),
      width: 1.0,
    ),
  ),
);

Widget attachCard(String imageAdrs, String text) {
  return Column(
    children: <Widget>[
      Flexible(
        child: ImageUtils.fromLocal(
          imageAdrs,
          width: 8.w,
          height: 8.w,
        ),
        flex: 1,
      ),
      Space(height: 1.h),
      Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color.fromARGB(255, 148, 148, 148),
          fontSize: 12.sp,
        ),
      ),
    ],
  );
}

Widget attachBox() {
  return Stack(
    children: <Widget>[
      Positioned(
        child: Container(
          width: double.infinity,
          height: 18.5.h,
        ),
      ),
      Positioned(
        top: 2.h,
        right: 0.0,
        left: 0.0,
        child: Container(
          height: 16.5.h,
          padding: EdgeInsets.only(
            bottom: 4.h,
            top: 4.h,
            left: 3.w,
            right: 3.w,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 246, 246, 246),
                spreadRadius: 7.0,
                blurRadius: 12.0,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    debugPrint('assistant clicked');
                    Utils.launchURL('http://support.kermany.com/');
                  },
                  child: attachCard('assets/images/profile/assistant.svg', 'دستیار'),
                ),
              ),
              Container(
                width: 0.5.w,
                height: 10.h,
                color: Color.fromARGB(255, 237, 237, 237),
              ),
              Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () => Utils.launchURL('https://kermany.com/'),
                  child: attachCard('assets/images/profile/magazine.svg', 'مجله دکتر کرمانی'),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        top: 0.0,
        right: 0,
        left: 0,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.0),
              color: Colors.white,
            ),
            width: 12.w,
            height: 12.w,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Color.fromARGB(255, 243, 243, 243),
                ),
                width: 9.w,
                height: 9.w,
                child: Center(
                  child: ImageUtils.fromLocal(
                    'assets/images/profile/attach.svg',
                    width: 4.5.w,
                    height: 4.5.w,
                    color: Color.fromARGB(255, 204, 204, 204),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget optionButtonUi(IconData icon, String text, int action, TextDirection textDirection) {
  return GestureDetector(
    onTap: () {
      if (action == 2) {
        navigator.routeManager.push(Uri.parse(Routes.editProfile));
      } else if (action == 1) {
        navigator.routeManager.push(Uri.parse(Routes.billSubscriptionHistory));
      } else if (action == 0) {
        navigator.routeManager.push(Uri.parse(Routes.resetCode));
      }
    },
    child: Container(
//        width: _widthSpace / 3.25,
      height: 6.h,
      padding: EdgeInsets.only(left: 8, right: 8),
      decoration:
      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30.0), boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 248, 233, 233),
            blurRadius: 3.0,
            spreadRadius: 2.5,
            offset: Offset(0.0, 0.3.w)),
      ]),
      child: Row(
        textDirection: textDirection,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 0,
            child: Icon(
              icon,
              color: Color.fromARGB(255, 255, 151, 156),
              size: 5.w,
            ),
          ),
          Space(
            width: 1.w,
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10.sp,
              color: Color.fromARGB(255, 152, 152, 152),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget cardLeftOrRightColor(String bgAdrs, String iconAdrs, String text, Color textColor,
    Color shadow, TextDirection textDirection, bool isRight) {
  return Container(
    width: 70.w,
    height: 10.h,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30.0),
      boxShadow: [
        BoxShadow(
          color: shadow,
          spreadRadius: 7.0,
          blurRadius: 12.0,
        ),
      ],
    ),
    child: Stack(
      alignment: Alignment.center,
      textDirection: textDirection,
      children: <Widget>[
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isRight)
                Expanded(
                  child: Container(
                    width: 1.5.w,
                    decoration: BoxDecoration(
                        color: Color(0xff66D4C9),
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(12), topRight: Radius.circular(12))),
                  ),
                  flex: 0,
                ),
              Expanded(
                  flex: 1,
                  child: Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Text(
                        "",
                        textAlign: TextAlign.right,
                      ))),
              if (!isRight)
                Expanded(
                  child: Container(
                    width: 1.5.w,
                    decoration: BoxDecoration(
                        color: Color(0xff66D4C9),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12), topLeft: Radius.circular(12))),
                  ),
                  flex: 0,
                ),
            ],
          ),
        ),
        Container(
          width: 65.w,
          height: 10.h,
          child: Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  text,
                  textAlign: TextAlign.center,
                  softWrap: true,
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                  ),
                ),
                Space(
                  width: 3.w,
                ),
                ImageUtils.fromLocal(
                  iconAdrs,
                  width: 12.w,
                  height: 12.w,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget textInput({required double height,
  TextInputType? textInputType,
  required Function validation,
  required Function onChanged,
  String? value,
  String? label,
  Color? bgColor,
  required bool enable,
  required bool maxLine,
  required BuildContext ctx,
  TextInputAction? action,
  required TextDirection textDirection,
  TextAlign? textAlign,
  bool? endCursorPosition,
  TextEditingController? textController,
  List<TextInputFormatter>? formatters,
  IconData? icon}) {
  TextEditingController controller = TextEditingController();
  controller.text = value ?? '';
  //controller.selection = TextSelection.fromPosition(TextPosition(offset: controller.text.length));
  return Container(
    height: height,
    child: TextFormField(
        inputFormatters: formatters != null ? formatters : null,
        textInputAction: action,
        maxLines: maxLine ? 4 : 1,
        controller: textController ?? controller,
        enabled: enable,
        decoration: inputDecoration
            .copyWith(
            labelText: label,
            fillColor: bgColor,
            labelStyle: Theme.of(ctx)
            .textTheme
            .subtitle1!
            .copyWith(color: AppColors.labelColor),
        prefixIcon: icon != null ? Icon(icon) : null),
    keyboardType: textInputType,
    textDirection: textDirection,
    onChanged: (val) {
      if (textController != null) {
        TextSelection previousSelection = textController.selection;
        onChanged(val);
        textController.text = val;
        textController.selection = previousSelection;
      } else {
        TextSelection previousSelection = controller.selection;
        controller.text = onChanged(val);
        controller.selection = previousSelection;
      }
    },
    style: Theme
        .of(ctx)
        .textTheme
        .bodyText1,
    // textAlign: TextAlign.start,
    validator: (val) => validation(val),
  ),);
}
