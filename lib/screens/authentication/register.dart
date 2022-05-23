import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/auth_header.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/gender_switch.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

enum gender {
  @JsonValue(0)
  woman,
  @JsonValue(1)
  man
}

class RegisterScreen extends StatefulWidget {
  RegisterScreen() {
    MemoryApp.analytics!.logEvent(name: "register_start");
  }

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ResourcefulState<RegisterScreen> {
  var args;

  String? firstName;
  String? lastName;
  String? _password;
  late AuthenticationBloc authBloc;
  bool switchValue = false;
  bool _obscureText = false;
  bool check = false;

  @override
  void initState() {
    super.initState();
    authBloc = AuthenticationBloc();
    listenBloc();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      print('event:$event');
      if (event != null) {
        check = true;
        VxNavigator.of(context).push(Uri.parse('/$event'));
      }
    });
    authBloc.showServerError.listen((event) {
      VxNavigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    args = ModalRoute.of(context)!.settings.arguments;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        AuthHeader(
                          title: intl.register,
                        ),
                        Space(height: 3.h),
                        content(),
                      ]),
                    ),
                  );
                } else {
                  check = false;
                  return Center(
                      child: Container(
                          width: 15.w, height: 15.w, child: Progress()));
                }
              })),
    );
  }

  Widget content() {
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.arcColor),
              child: Text("+ ${args['mobile']}",
                  textDirection: TextDirection.ltr,
                  style: TextStyle(color: AppColors.penColor))),
          Space(height: 3.h),
          Container(
            height: 10.h,
            child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: intl.name,
                    labelStyle:
                        TextStyle(color: AppColors.penColor, fontSize: 16.0),
                    // errorText:
                    // _validate ? intl.fillAllField : null,
                    suffixStyle: TextStyle(color: Colors.green)),
                onChanged: (txt) {
                  firstName = txt;
                }),
          ),
          Space(height: 3.h),
          Container(
            height: 10.h,
            child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)),
                    labelText: intl.lastName,
                    labelStyle:
                        TextStyle(color: AppColors.penColor, fontSize: 16.0),
                    // errorText:
                    // _validate ? intl.fillAllField : null,
                    suffixStyle: TextStyle(color: Colors.green)),
                onChanged: (txt) {
                  lastName = txt;
                }),
          ),
          Space(height: 3.h),
          Container(
            height: 10.h,
            child: TextField(
              obscureText: !_obscureText,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.penColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.penColor),
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: intl.password,
                  // errorText:
                  // _validate ? intl.fillAllField : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.penColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  labelStyle:
                      TextStyle(color: AppColors.penColor, fontSize: 18.0)),
              onChanged: (txt) {
                _password = txt;
              },
            ),
          ),
          Space(height: 3.h),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(intl.woman,
                    style:
                        TextStyle(fontSize: 14.0, color: AppColors.penColor)),
                Space(width: 3.w),
                ToggleSwitch(
                  minWidth: 90.0,
                  minHeight: 45.0,
                  initialLabelIndex: 0,
                  cornerRadius: 25.0,
                  activeFgColor: AppColors.primary,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  icons: [
                    'assets/images/registry/gender_woman.svg',
                    'assets/images/registry/gender_man.svg',
                    'assets/images/registry/gender_woman_selected.svg',
                    'assets/images/registry/gender_man_selected.svg',
                  ],
                  iconSize: 30.0,
                  activeBgColors: [
                    [Colors.red, Colors.pinkAccent],
                    [Color(0xff3b5998), Color(0xff8b9dc3)]
                  ],
                  animate: true,
                  // with just animate set to true, default curve = Curves.easeIn
                  animationDuration: 200,
                  curve: Curves.bounceInOut,
                  // animate must be set to true when using custom curve
                  onToggle: (index) {
                    index == gender.man.index
                        ? switchValue = true
                        : switchValue = false;
                  },
                ),
                Space(width: 3.w),
                Text(intl.man,
                    style:
                        TextStyle(fontSize: 14.0, color: AppColors.penColor)),
              ],
            ),
          ),
          Space(height: 3.h),
          SubmitButton(
              label: intl.register, size: Size(100.w, 8.h), onTap: clickSubmit),
        ],
      ),
    );
  }

  void clickSubmit() {
    if (firstName != null && lastName != null) {
      Register register = Register();
      register.firstName = firstName;
      register.lastName = lastName;
      register.mobile = args['mobile'];
      register.password = _password;
      register.gender = switchValue;
      register.verifyCode = args['code'];
      register.countryId = args['id'];
      register.appId = '0';
      authBloc.registerMethod(register);
    } else
      Utils.getSnackbarMessage(context, intl.fillAllField);
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    clickSubmit();
  }
}
