import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/authentication/auth_header.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/widget/button.dart';
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
          VxNavigator.of(context).push(Uri(
              path: '${Routes.passVerify}',
              queryParameters: {"mobile": args['mobile'], 'countryId': '${args['countryId']}'}));
          IntentUtils.openAppIntent(Uri.encodeFull(
            'https://wa.me/${MemoryApp.whatsappInfo!.botMobile!}?text=${MemoryApp.whatsappInfo!.botStartText!}',
          ));
        } else if (event.toString().contains(Routes.auth.substring(1)))
          VxNavigator.of(context).push(Uri(
              path: '/$event',
              queryParameters: {"mobile": args['mobile'], 'countryId': '${args['countryId']}'}));
        else
          VxNavigator.of(context).clearAndPush(Uri.parse(Routes.listView));
      }
    });
    authBloc.showServerError.listen((event) {
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      debugPrint('login args $args');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.arcColor,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Color(0xffb4babb),
            onPressed: () => VxNavigator.of(context).pop()),
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: authBloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.data == false && !check) {
                return TouchMouseScrollable(
                    child: SingleChildScrollView(
                  child: Column(children: [
                    AuthHeader(
                      title: intl.login,
                    ),
                    content(),
                  ]),
                ));
              } else {
                check = false;
                return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
              }
            }),
      ),
    );
  }

  Widget content() {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, left: 20.0),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0), color: AppColors.arcColor),
              child: Text(
                "+ ${args['mobile']}",
                textDirection: TextDirection.ltr,
                style: TextStyle(color: AppColors.penColor),
              )),
          Space(height: 2.h),
          Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(15.0), color: AppColors.arcColor),
            child: TextField(
              controller: _text,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.penColor),
                    borderRadius: BorderRadius.circular(15.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey)),
                labelText: intl.password,
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
          SizedBox(height: 8.h),
          button(AppColors.btnColor, intl.login, Size(100.w, 8.h), clickButton),
          SizedBox(height: 8.h),
          InkWell(
              child: Text(
                intl.forgetPassword,
                style: TextStyle(fontSize: 16.sp, color: AppColors.penColor),
              ),
              onTap: () => changePassDialog())
        ],
      ),
    );
  }

  void changePassDialog() {
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
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
    if (authBloc.isTrySendCode) {
      authBloc.sendCodeMethod(args['mobile'], channelSendCode);
    } else {
      clickButton();
    }
  }
}
