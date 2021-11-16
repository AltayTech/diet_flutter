import 'dart:async';

import 'package:behandam/base/utils.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/modal/modal.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/authentication/login.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/button.dart';
import 'package:behandam/widget/pin_code_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:behandam/screens/utility/arc.dart';
import '../../routes.dart';

class CodeResetScreen extends StatefulWidget {
  @override
  _CodeResetScreenState createState() => _CodeResetScreenState();
}

class _CodeResetScreenState extends ResourcefulState<CodeResetScreen> {
  late AuthenticationBloc authBloc;
  var args;
  String? firstP;
  String? secondP;
  String? thirdP;
  String? fourthP;
  String? code;
  late Timer _timer;
  int _start = 15;
  bool flag = false;
  final focus = FocusNode();
  bool check = false;

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            flag = true;
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
    authBloc  = AuthenticationBloc();
    listenBloc();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if(event == true){
        check = true;
        VxNavigator.of(context).push(Uri.parse(Routes.resetPass),params: {"mobile": args, "code": code});
      }
    });
    authBloc.showServerError.listen((event) {
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
              builder: (context, snapshot){
                if (snapshot.data == false && !check) {
                  return NestedScrollView(
                      headerSliverBuilder:  (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverAppBar(
                            backgroundColor: AppColors.arcColor,
                            elevation: 0.0,
                            leading: IconButton( icon: Icon(Icons.arrow_back_ios),
                                color: Color(0xffb4babb),
                                onPressed: () => VxNavigator.of(context).pop()),
                            // floating: true,
                            forceElevated: innerBoxIsScrolled,
                          ),
                        ];
                      },
                      body: SingleChildScrollView(
                      child: Column(
                          children: [
                            header(),
                            SizedBox(height: 80.0),
                            content(),
                          ]),
                  ),
                    );}
                else{
                  check = false;
                  return Center(
                      child: Container(
                          width:15.w,
                          height: 15.w,
                          child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 1.0)));
                }
              })
      ),
    );
  }
  Widget header(){
    return Stack(
      // alignment: Alignment.center,
      // fit: StackFit.loose,
      overflow: Overflow.visible,
      children: [
        RotatedBox(quarterTurns: 90, child: MyArc(diameter: 150)),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text(intl.changePassword, style: TextStyle(
                  color: AppColors.penColor,
                  fontSize: 22.0,
                  fontFamily: 'Iransans-Bold',
                  fontWeight: FontWeight.w700),
                  textAlign: TextAlign.center)
          ),
        ),
        Positioned(
          top: 60.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: SvgPicture.asset('assets/images/registry/pass_logo.svg',
              width: 120.0,
              height: 120.0,),
          ),
        ),
      ],
    );
  }

  Widget content(){
    return Padding(
      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.arcColor),
              child: Text("+ $args",textDirection: TextDirection.ltr,
                style: TextStyle(color: AppColors.penColor),)),
          SizedBox(height: 5.h),
          Text(intl.smsCode,style: TextStyle(fontSize: 16.0)),
          SizedBox(height: 2.h),
          Container(
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: pinCodeInput(
                widthSpace: MediaQuery.of(context).size.width ,
                onDone: (val) => setState(() {
                  code = val;
                }),
                context: context,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Container(child: flag
              ? InkWell(child:
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.reset_tv,color: AppColors.penColor),
              SizedBox(width: 2.w),
              Text(intl.notSend, style: TextStyle(fontSize: 14.0)),
            ],
          ),
              onTap: () =>  setState(() {
                authBloc.sendCodeMethod(args);
                flag = false;
                _start = 15;
                startTimer();
              }))
              : Text( intl.sendAgain + '$_start', style: TextStyle(fontSize: 14.0))),
          SizedBox(height: 10.h),
          button(AppColors.btnColor,intl.confirmNewPassword,Size(100.w,8.h),
                  () {
                VerificationCode verify = VerificationCode();
                verify.mobile = args;
                verify.verifyCode = code;
                verify.resetPass = '1';
                authBloc.verifyMethod(verify);
              }
          ),
        ],
      ),
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }
}