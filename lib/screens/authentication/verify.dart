import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/login_background.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
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

class _VerifyScreenState extends ResourcefulState<VerifyScreen> with CodeAutoFill {
  late AuthenticationBloc authBloc;

  late TextEditingController _textCode = TextEditingController();
  late TextEditingController _textPhone = TextEditingController();

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

  bool isInit = false;

  late Country countrySelected;

  @override
  void dispose() {
    authBloc.dispose();
    if (!kIsWeb) unregisterListener();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;

      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      countrySelected = args["country"];
      _textPhone.text = '+${args["mobile"]}';
    }
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
          params: {"mobile": args['mobile'], "code": codeVerify, "country": countrySelected},
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
    return Scaffold(backgroundColor: Colors.white, body: body());
  }

  Widget body() {
    return SafeArea(
      child: StreamBuilder(
          stream: authBloc.waiting,
          builder: (context, snapshot) {
            if (snapshot.data == false && !check) {
              return TouchMouseScrollable(
                child: SingleChildScrollView(
                  child: LoginBackground(
                    children: [
                      Space(height: 12.h),
                      Expanded(child: content()),
                    ],
                  ),
                ),
              );
            } else {
              check = false;
              return Container(height: 100.h, child: Progress());
            }
          }),
    );
  }

  Widget content() {
    return Container(
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
                  intl.enterCodeSent,
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
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(children: [
                  Expanded(
                    child: Container(
                      width: 15.w,
                      height: 7.h,
                      padding: EdgeInsets.only(top: 4),
                      child: StreamBuilder<int>(
                          stream: authBloc.start,
                          builder: (context, start) {
                            if (start.hasData)
                              return Center(
                                child: Text('${DateTimeUtils.timerFormat(start.requireData)}',
                                    style: TextStyle(fontSize: 12.sp)),
                              );
                            else
                              return Text('');
                          }),
                    ),
                  ),
                  Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          _textPhone.text,
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
            ),
            Space(height: 1.h),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: pinCodeInput(
                    widthSpace: 85.w,
                    height: 7.h,
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
                            MemoryApp.analytics!.logEvent(name: "auto_verify_code");
                          } else {
                            MemoryApp.analytics!.logEvent(name: "manual_verify_code");
                          }
                          authBloc.verifyMethod(verification);

                          authBloc.setTrySendCode = false;
                        }
                      }
                    },
                    textController: _textCode,
                    context: context,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  ImageUtils.fromLocal('assets/images/registry/call.svg', width: 4.w, height: 4.w),
                  Space(width: 1.w),
                  Text(
                    intl.forSendCodeCallMe,
                    textAlign: TextAlign.start,
                    textDirection: TextDirection.ltr,
                    style: typography.overline!.copyWith(color: AppColors.priceGreenColor),
                  ),
                ],
              ),
            ),
            Space(height: 4.h),
            StreamBuilder(
              stream: authBloc.selectedCountry,
              builder: (_, AsyncSnapshot<Country> snapshot) {
                return CustomButton(
                  AppColors.btnColor,
                  intl.login,
                  Size(100.w, 6.h),
                  () {
                    DialogUtils.showDialogProgress(context: context);
                    VerificationCode verification = VerificationCode();
                    verification.mobile = args['mobile'];
                    verification.verifyCode = codeVerify;
                    if (navigator.currentConfiguration!.path.contains('pass'))
                      verification.resetPass = true;
                    debugPrint('query verify ${verification.toJson()}');
                    authBloc.verifyMethod(verification);

                    authBloc.setTrySendCode = false;
                  },
                );
              },
            ),
            Space(height: 2.h),
          ],
        ),
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
                      onPressed: () {
                        channelSendCode = ChannelSendCode.WHATSAPP;
                        authBloc.tryCodeMethod(args['mobile'], channelSendCode);
                        authBloc.setTrySendCode = true;
                        authBloc.setFlag = false;
                        authBloc.startTimer();

                        Navigator.of(context).pop();
                        IntentUtils.openAppIntent(Uri.encodeFull(
                          'https://wa.me/${MemoryApp.whatsappInfo!.botMobile!}?text=${MemoryApp.whatsappInfo!.botStartText!}',
                        ));
                      },
                      icon: Icon(
                        Icons.whatsapp,
                        size: 7.w,
                        color: Colors.white,
                      ),
                      label: Text(
                        intl.sendWhatsapp,
                        textAlign: TextAlign.start,
                        style: Theme.of(context).textTheme.button!.copyWith(color: Colors.white),
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
      if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

      VerificationCode verification = VerificationCode();
      verification.mobile = args['mobile'];
      verification.verifyCode = codeVerify;
      if (navigator.currentConfiguration!.path.contains('pass')) verification.resetPass = true;
      debugPrint('query verify ${verification.toJson()}');
      authBloc.verifyMethod(verification);

      authBloc.setTrySendCode = false;
    }
  }

  @override
  void codeUpdated() {
    unregisterListener();
    isAutoVerify = true;
    _textCode.text = code!;
  }
}
