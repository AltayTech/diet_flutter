import 'package:behandam/app/app.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

void fieldFocusChange(BuildContext context, FocusNode currentFocus, FocusNode nextFocus) {
  currentFocus.unfocus();
  FocusScope.of(context).requestFocus(nextFocus);
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
  labelText: 'شماره موبایلت رو وارد کن',
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
      SizedBox(height: 1.h),
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
                    print('assistant clicked');
                    launchURL('http://support.kermany.com/');
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
                  onTap: () => launchURL('https://kermany.com/'),
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

Widget optionUi(IconData icon, String text, int action) {
  return GestureDetector(
    onTap: () {
      if (action == 2) {
        navigator.routeManager.push(Uri.parse(Routes.editProfile));
      } else if (action == 0) {
        // user.getUser['info'].mobile
        // Navigator.of(context).pushNamed(ProfileChangePass.routeName, arguments: user.mobile);
        // Navigator.of(context)
        //     .push(MaterialPageRoute(builder: (ctx) => ProfileChangePass()));
      }
    },
    child: Container(
//        width: _widthSpace / 3.25,
      height: 6.h,
      decoration:
          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30.0), boxShadow: [
        BoxShadow(
            color: Color.fromARGB(255, 248, 233, 233),
            blurRadius: 4.0,
            spreadRadius: 3.0,
            offset: Offset(0.0, 0.35.w)),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            text,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 4.5.w,
              color: Color.fromARGB(255, 152, 152, 152),
            ),
          ),
          SizedBox(
            width: 1.w,
          ),
          Icon(
            icon,
            color: Color.fromARGB(255, 255, 151, 156),
             size: 7.w,
          ),
        ],
      ),
    ),
  );
}

Widget card(String bgAdrs, String iconAdrs, String text, Color textColor, Color shadow,
    TextDirection textDirection) {
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
                SizedBox(
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

Widget textInput(
    {required double height,
    TextInputType? textInputType,
    required Function validation,
    required Function onChanged,
    String? value,
    String? label,
    required bool enable,
    required bool maxLine,
    required BuildContext ctx,
    TextInputAction? action,
    required TextDirection textDirection,
    FilteringTextInputFormatter? formatter}) {
  return Container(
    height: height,
    child: Directionality(
      textDirection: textDirection,
      child: TextFormField(
        inputFormatters: formatter != null
            ? [
                formatter,
              ]
            : null,
        textInputAction: action,
        maxLines: maxLine ? 4 : 1,
        controller: TextEditingController(text: value),
        enabled: enable,
        decoration: inputDecoration.copyWith(
          labelText: label,
          labelStyle: Theme.of(ctx).textTheme.subtitle1!.copyWith(color: AppColors.labelColor),
        ),
        keyboardType: textInputType,
        onChanged: (val) => onChanged(val),
        style: Theme.of(ctx).textTheme.subtitle2,
        validator: (val) => validation(val),
      ),
    ),
  );
}

void launchURL(String url) async {
  // url = Uri.encodeFull(url).toString();
  if (await canLaunch(url)) {
    print('can launch');
    await launch(
      url,
      forceSafariVC: false,
      forceWebView: false,
      enableJavaScript: true,
      headers: <String, String>{'my_header_key': 'my_header_value'},
    );
  } else {
    // throw 'Could not launch $url';
    print('url lanuch error');
  }
  /*url = Uri.encodeFull(url).toString();
    print('url $url');
    // Uri.encodeComponent(url);
    // print('scheme url ${url.substring(8, url.length - 1)}');
    // final Uri _openUrl = Uri(
    //     scheme: 'https',
    //     path: url.substring(8, url.length - 1),
    //     // queryParameters: {
    //     //   'subject': 'Example Subject & Symbols are allowed!'
    //     // }
    // );
    if (await canLaunch(url)) {
       await launch(url, forceSafariVC: false,
         forceWebView: false,);
    } else {
      showSnackbar('$url', SizeConfig.blockSizeHorizontal, true, _scaffoldKey);
      throw 'Could not launch $url';
    }*/
}
