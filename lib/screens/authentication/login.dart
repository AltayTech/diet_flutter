import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/login_background.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ResourcefulState<LoginScreen> {
  final _text = TextEditingController();
  late Map<String, dynamic> args;
  bool _obscureText = false;
  String _password = "";
  late AuthenticationBloc authBloc;
  bool check = false;
  ChannelSendCode channelSendCode = ChannelSendCode.SMS;

  late Country countrySelected;

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
      Navigator.pop(context);
      if (!event.toString().isEmptyOrNull) {
        check = true;

        if (channelSendCode == ChannelSendCode.WHATSAPP) {
          VxNavigator.of(context).push(
              Uri(
                path: '${Routes.passVerify}',
              ),
              params: {"mobile": args['mobile'], 'country': args['country']});
          IntentUtils.openAppIntent(Uri.encodeFull(
            'https://wa.me/${MemoryApp.whatsappInfo!.botMobile!}?text=${MemoryApp.whatsappInfo!.botStartText!}',
          ));
        } else if (event.toString().contains(Routes.auth.substring(1)))
          VxNavigator.of(context).push(
              Uri(
                path: '${Routes.passVerify}',
              ),
              params: {"mobile": args['mobile'], 'country': args['country']});
        else
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
      }
    });
    authBloc.popDialog.listen((event) {
      Navigator.of(context).pop();
    });
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      countrySelected = args["country"];

      debugPrint('login args $args');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(backgroundColor: Colors.white, body: body());
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return LoginBackground(
                    children: [
                      content(),
                    ],
                  );
                } else {
                  check = false;
                  return Container(height: 100.h, child: Progress());
                }
              }),
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      width: 100.w,
      height: 62.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1))
          ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.registerLogin,
              textAlign: TextAlign.start,
              style: typography.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Space(height: 1.h),
            Row(
              children: [
                Text(
                  intl.enterPassword,
                  textAlign: TextAlign.start,
                  style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
                ),
                Space(width: 1.w),
                InkWell(
                  onTap: () {
                    context.vxNav.clearAndPush(Uri.parse(Routes.auth));
                  },
                  child: Text(
                    intl.editPhone,
                    textAlign: TextAlign.start,
                    style: typography.caption!.copyWith(
                        color: AppColors.redBar, fontWeight: FontWeight.bold, fontSize: 10.sp),
                  ),
                ),
              ],
            ),
            Space(height: 3.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 7.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(children: [
                  Expanded(
                      flex: 5,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, left: 8),
                        child: Text(
                          '+${args["mobile"]}',
                          textAlign: TextAlign.start,
                          textDirection: TextDirection.ltr,
                          style: typography.caption!
                              .copyWith(fontSize: 14.sp, fontWeight: FontWeight.w500),
                        ),
                      )),
                  Expanded(
                    flex: 0,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, top: 8, bottom: 8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: ImageUtils.fromLocal(countrySelected.flag!,
                            package: picker.countryCodePackageName,
                            width: 7.w,
                            fit: BoxFit.fill,
                            height: 5.5.w),
                      ),
                    ),
                  ),
                ]),
              ),
            ),
            Space(height: 1.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _text,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0)),
                  // enabledBorder: OutlineInputBorder(
                  //   borderSide: BorderSide(color: Colors.grey)),
                  labelText: intl.password,
                  prefixIcon: IconButton(
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
                  // errorText: _validate ? intl.fillAllField : null,
                  labelStyle: TextStyle(color: AppColors.penColor, fontSize: 12.sp),
                ),
                obscureText: !_obscureText,
                onSubmitted: (String) {
                  clickButton();
                },
                onChanged: (txt) {
                  _password = txt;
                },
              ),
            ),
            Space(height: 3.h),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () => loginWithOtpDialog(),
                child: Text(
                  intl.loginWithOtp,
                  textAlign: TextAlign.start,
                  textDirection: TextDirection.ltr,
                  style: typography.overline!.copyWith(color: AppColors.priceGreenColor),
                ),
              ),
            ),
            Space(height: 5.h),
            CustomButton(
              AppColors.btnColor,
              intl.login,
              Size(100.w, 6.h),
              () {
                clickButton();
              },
            ),
            Space(height: 2.h),
          ],
        ),
      ),
    );
  }

  void loginWithOtpDialog() {
    DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              close(),
              Container(
                width: 70.w,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    text: intl.textChangePass1,
                    style: TextStyle(fontSize: 14.sp, color: AppColors.penColor),
                    children: <TextSpan>[
                      TextSpan(
                          text: '${args['mobile']}', style: TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(text: intl.textChangePass2),
                    ],
                  ),
                ),
              ),
              Space(height: 2.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextButton.icon(
                      onPressed: () {
                        channelSendCode = ChannelSendCode.SMS;

                        Navigator.pop(context);
                        DialogUtils.showDialogProgress(context: context);

                        MemoryApp.forgetPass = true;
                        authBloc.sendCodeMethod(args['mobile'], channelSendCode);
                        authBloc.setTrySendCode = true;
                      },
                      icon: Icon(
                        Icons.sms,
                        size: 7.w,
                        color: Colors.white,
                      ),
                      label: Text(
                        intl.sendSMS,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.blueRuler,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: AppColors.blueRuler,
                                width: 0.25.w,
                              )))),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextButton.icon(
                      onPressed: () async {
                        if (MemoryApp.whatsappInfo != null &&
                            MemoryApp.whatsappInfo!.botStatusBool) {
                          channelSendCode = ChannelSendCode.WHATSAPP;
                          Navigator.pop(context);
                          DialogUtils.showDialogProgress(context: context);
                          authBloc.sendCodeMethod(args['mobile'], channelSendCode);

                          MemoryApp.forgetPass = true;

                          authBloc.setTrySendCode = true;
                        } else {
                          Navigator.pop(context);
                          Utils.getSnackbarMessage(context, intl.errorDisableWhatsApp);
                        }
                      },
                      icon: Icon(
                        Icons.whatsapp,
                        size: 7.w,
                        color: Colors.white,
                      ),
                      label: Text(
                        intl.sendWhatsapp,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.button!.copyWith(
                            color: (MemoryApp.whatsappInfo != null &&
                                    MemoryApp.whatsappInfo!.botStatusBool)
                                ? Colors.white
                                : AppColors.labelTextColor),
                      ),
                      style: OutlinedButton.styleFrom(
                          backgroundColor: (MemoryApp.whatsappInfo != null &&
                                  MemoryApp.whatsappInfo!.botStatusBool)
                              ? AppColors.greenRuler
                              : AppColors.grey,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: (MemoryApp.whatsappInfo != null &&
                                        MemoryApp.whatsappInfo!.botStatusBool)
                                    ? AppColors.greenRuler
                                    : AppColors.grey,
                                width: 0.25.w,
                              )))),
                )
              ]),
              Space(height: 2.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget close() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: AppDecorations.boxSmall.copyWith(
            color: AppColors.primary.withOpacity(0.4),
          ),
          padding: EdgeInsets.all(1.w),
          child: Icon(
            Icons.close,
            size: 6.w,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  void clickButton() {
    if (_password.length > 0) {
      User user = User();
      user.mobile = args['mobile'];
      user.password = _password;
      DialogUtils.showDialogProgress(context: context);
      authBloc.passwordMethod(user);

      authBloc.setTrySendCode = false;
    } else
      Utils.getSnackbarMessage(context, intl.pleaseEnterPassword);
  }

  @override
  void onRetryLoadingPage() {
    //if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    //bloc.onRetryLoadingPage();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog)
      DialogUtils.showDialogProgress(context: context);

    authBloc.setRepository();

    if (authBloc.isTrySendCode) {
      authBloc.sendCodeMethod(args['mobile'], channelSendCode);
    } else {
      clickButton();
    }
  }
}
