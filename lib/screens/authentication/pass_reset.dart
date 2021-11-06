import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/helper/Arc.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../routes.dart';

class PasswordResetScreen extends StatefulWidget {
  @override
  _PasswordResetScreenState createState() => _PasswordResetScreenState();
}

class _PasswordResetScreenState extends ResourcefulState<PasswordResetScreen> {
  final _text = TextEditingController();
  var args;
  bool _validate = false;
  String? _password1;
  String? _password2;
  late AuthenticationBloc authBloc;
  bool?  _switchValue;
  bool _obscureText1 = false;
  bool _obscureText2 = false;
  bool check = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authBloc  = AuthenticationBloc();
    listenBloc();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if(event == true){
        check = true;
        VxNavigator.of(context).push(Uri.parse(Routes.home));
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
    return Scaffold(
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
            }));
  }
  Widget header(){
    return  Stack(
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
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 60.0,
            child: TextField(
              obscureText: !_obscureText1,
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
                      _obscureText1
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.penColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText1 = !_obscureText1;
                      });
                    },
                  ),
                  labelStyle: TextStyle(color: AppColors.penColor,fontSize: 18.0)),
              onChanged: (txt) {
                _password1 = txt;
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 60.0,
            child: TextField(
              obscureText: !_obscureText2,
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
                      _obscureText2
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.penColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText2 = !_obscureText2;
                      });
                    },
                  ),
                  labelStyle: TextStyle(color: AppColors.penColor,fontSize: 18.0)),
              onChanged: (txt) {
                _password2 = txt;
              },
            ),
          ),
          SizedBox(height: 20.0),
          button(AppColors.btnColor, intl.setNewPassword,Size(100.w,8.h),
                  () {
                if (_password1 != _password2)
                  Utils.getSnackbarMessage(context, intl.notEqualPassword);
                else if(_password1 == null || _password2 == null)
                  Utils.getSnackbarMessage(context, intl.fillAllField);
                else if(_password1!.length < 4 || _password1!.length > 4)
                  Utils.getSnackbarMessage(context, intl.minimumPasswordLength);
                else if (_password1 == _password2) {
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