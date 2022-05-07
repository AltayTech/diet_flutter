import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ResourcefulState<PasswordResetScreen> {
  var args;
  String? _password1;
  String? _password2;
  late AuthenticationBloc authBloc;

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
      if (event != null) context.vxNav.clearAndPush(Uri(path: '/$event'));
    });
    authBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
        backgroundColor: Colors.white,
        body: StreamBuilder(
            stream: authBloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.data == false && !check) {
                return NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        backgroundColor: AppColors.arcColor,
                        elevation: 0.0,
                        leading: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            color: Color(0xffb4babb),
                            onPressed: () => VxNavigator.of(context).pop()),
                        // floating: true,
                        forceElevated: innerBoxIsScrolled,
                      ),
                    ];
                  },
                  body: TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        header(),
                        Space(height: 10.h),
                        content(),
                      ]),
                    ),
                  ),
                );
              } else {
                check = false;
                return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
              }
            }));
  }

  Widget header() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        RotatedBox(quarterTurns: 90, child: MyArc(diameter: 150)),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text(intl.changePassword,
                  style: TextStyle(
                      color: AppColors.penColor,
                      fontSize: 22.0,
                      fontFamily: 'Iransans-Bold',
                      fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center)),
        ),
        Positioned(
          top: 10.h,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal(
              'assets/images/registry/pass_logo.svg',
              width: 15.w,
              height: 15.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget content() {
    return Padding(
      padding: EdgeInsets.only(left: 8.w, right: 8.w),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 10.h,
            child: StreamBuilder<bool>(
              stream: authBloc.obscureTextPass,
              builder: (context, obscureTextPass) {
                return TextField(
                  obscureText: !obscureTextPass.requireData,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: AppColors.penColor)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.penColor),
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: intl.enterNewPassword,
                      // errorText: _validate ? intl.fillAllField : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureTextPass.requireData ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.penColor,
                        ),
                        onPressed: () {
                         authBloc.setObscureTextPass();
                        },
                      ),
                      labelStyle: TextStyle(color: AppColors.penColor, fontSize: 18.0)),
                  onChanged: (txt) {
                    _password1 = txt.toEnglishDigit();
                  },
                );
              }
            ),
          ),
          Space(height: 3.h),
          Container(
            height: 10.h,
            child: StreamBuilder<bool>(
              stream: authBloc.obscureTextConfirmPass,
              builder: (context, obscureTextConfirmPass) {
                return TextField(
                  obscureText: !obscureTextConfirmPass.requireData,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                      focusedBorder:
                          OutlineInputBorder(borderSide: BorderSide(color: AppColors.penColor)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: AppColors.penColor),
                          borderRadius: BorderRadius.circular(15.0)),
                      labelText: intl.repeatNewPassword,
                      // errorText: _validate ? intl.fillAllField : null,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureTextConfirmPass.requireData ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.penColor,
                        ),
                        onPressed: () {
                         authBloc.setObscureTextConfirmPass();
                        },
                      ),
                      labelStyle: TextStyle(color: AppColors.penColor, fontSize: 18.0)),
                  onChanged: (txt) {
                    _password2 = txt.toEnglishDigit();
                  },
                );
              }
            ),
          ),
          Space(height: 3.h),
          button(AppColors.btnColor, intl.setNewPassword, Size(100.w, 8.h), () {
            if (_password1 != _password2)
              Utils.getSnackbarMessage(context, intl.notEqualPassword);
            else if (_password1 == null || _password2 == null)
              Utils.getSnackbarMessage(context, intl.fillAllField);
            else if (_password1!.length < 4)
              Utils.getSnackbarMessage(context, intl.minimumPasswordLength);
            else {
              Reset pass = Reset();
              pass.password = _password1;
              authBloc.resetPasswordMethod(pass);
            }
          }),
        ],
      ),
    );
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    Reset pass = Reset();
    pass.password = _password1;
    authBloc.resetPasswordMethod(pass);
  }
}
