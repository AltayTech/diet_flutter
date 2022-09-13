import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
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
  bool _obscureText = false;
  bool check = false;
  late Country countrySelected;

  bool isInit = false;

  @override
  void initState() {
    super.initState();

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
    authBloc.popDialog.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      countrySelected = args["country"];
      authBloc = AuthenticationBloc();
      listenBloc();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: Toolbar(titleBar: intl.register),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: Column(children: [
                        Space(height: 1.h),
                        content(),
                      ]),
                    ),
                  );
                } else {
                  check = false;
                  return Center(child: Container(width: 15.w, height: 80.h, child: Progress()));
                }
              }),
        ));
  }

  Widget content() {
    return Stack(children: [
      Container(
        height: 80.h,
        child: Padding(
          padding: EdgeInsets.all(5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                intl.firstInfo,
                textAlign: TextAlign.start,
                style: typography.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Space(height: 1.h),
              Text(
                intl.pleaseFillInformation,
                textAlign: TextAlign.start,
                style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Space(height: 2.h),
              Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '+${args["mobile"]}',
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.ltr,
                          style: typography.caption!.copyWith(fontSize: 14.sp),
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: ImageUtils.fromLocal(
                          'assets/images/flags/${countrySelected.isoCode?.toLowerCase() ?? ''}.png',
                          width: 7.w,
                          height: 7.w),
                    ),
                  ),
                ]),
              ),
              Space(height: 2.h),
              TextField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10.0)),

                      hintText: intl.nameOptional,
                      hintStyle:
                      TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 16.0),
                      labelStyle:
                          TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 16.0),
                      // errorText:
                      // _validate ? intl.fillAllField : null,
                      suffixStyle: TextStyle(color: Colors.green)),
                  onChanged: (txt) {
                    firstName = txt;
                  }),
              Space(height: 2.h),
              TextField(
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                          borderRadius: BorderRadius.circular(10.0)),
                      hintText: intl.familyOptional,
                      hintStyle:
                      TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 16.0),
                      labelStyle:
                          TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 16.0),
                      // errorText:
                      // _validate ? intl.fillAllField : null,
                      suffixStyle: TextStyle(color: Colors.green)),
                  onChanged: (txt) {
                    lastName = txt;
                  }),
              Space(height: 2.h),
              TextField(
                obscureText: !_obscureText,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10.0)),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: intl.passwordOptional,
                    hintStyle:
                    TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 16.0),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.penColor.withOpacity(0.5),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    labelStyle:
                        TextStyle(color: AppColors.penColor.withOpacity(0.5), fontSize: 18.0)),
                onChanged: (txt) {
                  _password = txt;
                },
              ),
              Space(height: 1.h),
              Container(
                height: 5.h,
                decoration: BoxDecoration(
                    color: AppColors.priceGreenColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.priceGreenColor),
                      Space(width: 1.w),
                      Text(
                        intl.youCanSetPasswordForEachLogin,
                        textAlign: TextAlign.start,
                        style: typography.overline!.copyWith(color: AppColors.priceGreenColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        right: 4,
        left: 4,
        bottom: 0,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0, bottom: 16),
          child: CustomButton.withIcon(AppColors.btnColor, intl.nextStage, Size(100.w, 6.h),
              Icon(Icons.arrow_forward), clickSubmit),
        ),
      )
    ]);
  }

  void clickSubmit() {
      Register register = Register();
      register.firstName = firstName;
      register.lastName = lastName;
      register.password = _password;
      register.appId = '0';
      DialogUtils.showDialogProgress(context: context);
      authBloc.registerMethod(register);
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    clickSubmit();
  }
}
