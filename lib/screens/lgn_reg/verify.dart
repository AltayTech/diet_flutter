import 'dart:async';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/helper/Arc.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/pin_code_input.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'lgnReg_bloc.dart';

class VerifyScreen extends StatefulWidget {

  @override
  _VerifyScreenState createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  late LoginRegisterBloc loginBloc;
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
    loginBloc  = LoginRegisterBloc();
    listenBloc();
  }

  void listenBloc() {
    loginBloc.navigateToVerify.listen((event) {
      if(event == true)
        VxNavigator.of(context).push(Uri.parse(Routes.register),params: {"mobile": args['mobile'], "code": code , 'id': args['countryId']});
    });
    loginBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }


  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.ArcColor,
            elevation: 0.0,
            leading: IconButton( icon: Icon(Icons.arrow_back_ios),
                color: Color(0xffb4babb),
                onPressed: () => VxNavigator.of(context).pop())),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                // alignment: Alignment.center,
                // fit: StackFit.loose,
                overflow: Overflow.visible,
                children: [
                  RotatedBox(quarterTurns: 90, child: MyArc(diameter: 250)),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    left: 0.0,
                    child: Center(
                        child: Text('ثبت نام', style: TextStyle(fontSize: 22.0))
                    ),
                  ),
                  Positioned(
                    top: 60.0,
                    right: 0.0,
                    left: 0.0,
                    child: Center(
                      child: CircleAvatar(
                        radius: 60.0,
                        backgroundImage: AssetImage('assets/img-01.jpg'),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(15.0),
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                            color: AppColors.ArcColor),
                        child: Center(child: Text("+ ${args['mobile']}",textDirection: TextDirection.ltr))),
                    SizedBox(height: 20.0),
                    Text('کد پیامک شده رو اینجا وارد کن',style: TextStyle(fontSize: 18.0)),
                    SizedBox(height: 20.0),
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
                    SizedBox(height: 20.0),
                    Container(child: flag
                        ? InkWell(child:
                    Text('کد ارسال نشد، دوباره ارسال کن', style: TextStyle(fontSize: 14.0)),
                        onTap: () =>  setState(() {
                          loginBloc.sendMethod(args['mobile']);
                          flag = false;
                          _start = 15;
                          startTimer();
                        }))
                        : Text(' امکان ارسال مجدد بعد از : $_start', style: TextStyle(fontSize: 14.0))),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(AppColors.btnColor),
                            fixedSize: MaterialStateProperty.all(Size(350.0,60.0)),
                            // padding: MaterialStateProperty.all(
                            //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: BorderSide(color: AppColors.btnColor)))),
                        child: Text('ثبت نام',style: TextStyle(fontSize: 22.0),),
                        onPressed: () async {
                          // VerificationCode verification = VerificationCode();
                          // verification.mobile = widget.mobile;
                          // verification.verifyCode = code;
                          loginBloc.verifyMethod(args['mobile'], code!);
                        }
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
