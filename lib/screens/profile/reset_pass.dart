import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:velocity_x/velocity_x.dart';

class ResetPasswordProfile extends StatefulWidget {
  const ResetPasswordProfile({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ResourcefulState<ResetPasswordProfile> {
  late ProfileBloc profileBloc;
  String? _password1;
  String? _password2;

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc();
    profileBloc.showServerError.listen((event) {
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
    profileBloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.redBar,
      body: SafeArea(
        child: Stack(clipBehavior: Clip.none, children: [
          Positioned(
            top: 20.h,
            right: 0,
            left: 0,
            child: Container(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(35.0), topLeft: Radius.circular(35.0))),
              child: Column(
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    intl.changePassword,
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 8.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 60.0,
                          child: StreamBuilder<bool>(
                              stream: profileBloc.obscureTextPass,
                              builder: (context, obscureTextPass) {
                                if(obscureTextPass.hasData)
                                return TextField(
                                  obscureText: !obscureTextPass.requireData,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.penColor)),
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
                                          obscureTextPass.requireData
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: AppColors.penColor,
                                        ),
                                        onPressed: () {
                                          profileBloc.setObscureTextPass();
                                        },
                                      ),
                                      labelStyle:
                                          TextStyle(color: AppColors.penColor, fontSize: 14.sp)),
                                  onChanged: (txt) {
                                    _password1 = txt;
                                  },
                                );
                                else return EmptyBox();
                              }),
                        ),
                        SizedBox(height: 20.0),
                        Container(
                          height: 60.0,
                          child: StreamBuilder<bool>(
                              stream: profileBloc.obscureTextConfirmPass,
                              builder: (context, obscureTextConfirmPass) {
                                if(obscureTextConfirmPass.hasData)
                                return TextField(
                                  obscureText: !obscureTextConfirmPass.requireData,
                                  decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: AppColors.penColor)),
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
                                          obscureTextConfirmPass.requireData
                                              ? Icons.visibility
                                              : Icons.visibility_off,
                                          color: AppColors.penColor,
                                        ),
                                        onPressed: () {
                                          profileBloc.setObscureTextConfirmPass();
                                        },
                                      ),
                                      labelStyle:
                                          TextStyle(color: AppColors.penColor, fontSize: 14.sp)),
                                  onChanged: (txt) {
                                    _password2 = txt;
                                  },
                                );
                                else return EmptyBox();
                              }),
                        ),
                        SizedBox(height: 20.0),
                        CustomButton(AppColors.btnColor, intl.setNewPassword, Size(100.w, 8.h),
                            checkPassword),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 10.h,
            right: 0.0,
            left: 0.0,
            child: Center(
                child: Container(
              width: 30.w,
              height: 15.h,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 3, style: BorderStyle.solid),
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pinkPass.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 7,
                    offset: Offset(0, 5), // changes position of shadow
                  ),
                ],
                color: AppColors.pinkPass,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/images/profile/pass_lock.svg',
                  // width: 12.w,
                  // height: 5.h
                ),
              ),
            )),
          ),
          Positioned(
              top: 10.h,
              right: 5.w,
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: Center(
                      child: IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          alignment: Alignment.centerLeft,
                          color: Colors.white,
                          onPressed: () => VxNavigator.of(context).pop()))))
        ]),
      ),
    );
  }

  void checkPassword() {
    if (_password1 != _password2)
      Utils.getSnackbarMessage(context, intl.notEqualPassword);
    else if (_password1 == null || _password2 == null)
      Utils.getSnackbarMessage(context, intl.fillAllField);
    else if (_password1!.length < 4)
      Utils.getSnackbarMessage(context, intl.minimumPasswordLength);
    else if (_password1 == _password2) {
      Reset pass = Reset();
      pass.password = _password1;
      DialogUtils.showDialogProgress(context: context);
      profileBloc.resetPasswordMethod(pass);
    }
  }

  @override
  void onRetryLoadingPage() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    profileBloc.onRetryLoadingPage();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    profileBloc.onRetryAfterNoInternet();
    checkPassword();
  }
}
