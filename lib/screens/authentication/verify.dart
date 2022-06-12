import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/auth_header.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/widget/button.dart';
import 'package:behandam/widget/pin_code_input.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'authentication_bloc.dart';

class VerifyScreen extends StatefulWidget {
  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ResourcefulState<VerifyScreen>
    with CodeAutoFill {
  late AuthenticationBloc authBloc;
  late TextEditingController textEditingController = TextEditingController();
  var args;
  String? firstP;
  String? secondP;
  String? thirdP;
  String? fourthP;
  String? codeVerify;
  ChannelSendCode channelSendCode = ChannelSendCode.SMS;

  final focus = FocusNode();
  bool check = false;
  bool isRequest = false;
  bool isAutoVerify = false;

  @override
  void dispose() {
    authBloc.dispose();
    if (!kIsWeb) unregisterListener();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenSms();
    authBloc = AuthenticationBloc();
    authBloc.startTimer();
    listenBloc();
  }

  void listenSms() async {
    listenForCode(smsCodeRegexPattern: '\\d{4,6}');
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if (event != null) {
        debugPrint('verifiy ${navigator.currentConfiguration!.path} / $event');
        context.vxNav.replace(
          Uri(path: '/$event'),
          params: {
            "mobile": args['mobile'],
            "code": codeVerify,
            'id': args['countryId']
          },
        );
      }
    });
    authBloc.showServerError.listen((event) {
      isRequest = false;
      Navigator.of(context).pop();
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
                          title: navigator.currentConfiguration!.path
                                  .contains('pass')
                              ? intl.changePassword
                              : intl.register,
                        ),
                        Space(height: 80.0),
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
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.arcColor),
              child: Text(
                "+ ${args['mobile']}",
                textDirection: TextDirection.ltr,
                style: TextStyle(color: AppColors.penColor),
              )),
          Space(height: 5.h),
          Text(intl.smsCode, style: TextStyle(fontSize: 16.0)),
          Space(height: 2.h),
          Container(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: pinCodeInput(
                widthSpace: MediaQuery.of(context).size.width,
                onDone: (val) {
                  if (!isRequest) {
                    codeVerify = val;
                    debugPrint('verifyMethod => $codeVerify');
                    if (codeVerify!.length == 4) {
                      isRequest = true;
                      VerificationCode verification = VerificationCode();
                      verification.mobile = args['mobile'];
                      verification.verifyCode = codeVerify;
                      if (navigator.currentConfiguration!.path.contains('pass'))
                        verification.resetPass = true;
                      DialogUtils.showDialogProgress(context: context);
                      if (isAutoVerify) {
                        MemoryApp.analytics!.logEvent(name: "AutoVerifyCode");
                      } else {
                        MemoryApp.analytics!.logEvent(name: "ManualVerifyCode");
                      }
                      authBloc.verifyMethod(verification);

                      authBloc.setTrySendCode = false;
                    }
                  }
                },
                textController: textEditingController,
                context: context,
              ),
            ),
          ),
          Space(height: 8.h),
          Container(
              child: StreamBuilder<bool>(
                  stream: authBloc.flag,
                  builder: (context, flag) {
                    if (flag.hasData && flag.requireData)
                      return InkWell(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.reset_tv, color: AppColors.penColor),
                              Space(width: 2.w),
                              Text(intl.notSend,
                                  style: TextStyle(fontSize: 14.0)),
                            ],
                          ),
                          onTap: () {
                            methodSendCodeDialog();
                          });
                    else
                      return StreamBuilder<int>(
                          stream: authBloc.start,
                          builder: (context, start) {
                            if (start.hasData)
                              return Text(
                                  intl.sendAgain +
                                      '${DateTimeUtils.timerFormat(start.requireData)}',
                                  style: TextStyle(fontSize: 14.0));
                            else
                              return Text('');
                          });
                  })),
          Space(height: 8.h),
          button(AppColors.btnColor, intl.confirmContinue, Size(100.w, 8.h), () {
            DialogUtils.showDialogProgress(context: context);
            VerificationCode verification = VerificationCode();
            verification.mobile = args['mobile'];
            verification.verifyCode = codeVerify;
            if (navigator.currentConfiguration!.path.contains('pass'))
              verification.resetPass = true;
            debugPrint('query verify ${verification.toJson()}');
            authBloc.verifyMethod(verification);

            authBloc.setTrySendCode = false;
          }),
          Space(height: 5.h),
        ],
      ),
    );
  }

  void methodSendCodeDialog() {
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
              Text(
                intl.selectMethodSendCode,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Container(
                  margin: const EdgeInsets.only(left: 8, right: 8),
                  child: TextButton.icon(
                      onPressed: () {
                        channelSendCode = ChannelSendCode.SMS;
                        authBloc.tryCodeMethod(args['mobile'], channelSendCode);
                        authBloc.setTrySendCode = true;

                        authBloc.setFlag = false;
                        authBloc.startTimer();

                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.sms,
                        size: 7.w,
                        color: Colors.white,
                      ),
                      label: Text(
                        intl.sendSMS,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: Colors.white),
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
                      onPressed: () {
                        channelSendCode = ChannelSendCode.WHATSAPP;
                        authBloc.tryCodeMethod(args['mobile'], channelSendCode);
                        authBloc.setTrySendCode = true;

                        authBloc.setFlag = false;
                        authBloc.startTimer();

                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.whatsapp,
                        size: 7.w,
                        color: Colors.white,
                      ),
                      label: Text(
                        intl.sendWhatsapp,
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .button!
                            .copyWith(color: Colors.white),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.greenRuler,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: BorderSide(
                                color: AppColors.greenRuler,
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

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    if (authBloc.isTrySendCode) {
      authBloc.tryCodeMethod(args['mobile'], channelSendCode);
      authBloc.setFlag = false;
      authBloc.setTrySendCode = true;
    }
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
    if (!authBloc.isTrySendCode) {
      if (!MemoryApp.isShowDialog)
        DialogUtils.showDialogProgress(context: context);

      VerificationCode verification = VerificationCode();
      verification.mobile = args['mobile'];
      verification.verifyCode = codeVerify;
      if (navigator.currentConfiguration!.path.contains('pass'))
        verification.resetPass = true;
      debugPrint('query verify ${verification.toJson()}');
      authBloc.verifyMethod(verification);

      authBloc.setTrySendCode = false;
    }
  }

  @override
  void codeUpdated() {
    unregisterListener();
    isAutoVerify = true;
    textEditingController.text = code!;
  }
}
