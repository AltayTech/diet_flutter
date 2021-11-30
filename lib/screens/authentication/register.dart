import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/screens/authentication/authentication_bloc.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rolling_switch/rolling_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../routes.dart';

enum gender{
@JsonValue(0)
  woman,
@JsonValue(1)
  man
}

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ResourcefulState<RegisterScreen> {
  final _text = TextEditingController();
  var args;
  bool _validate = false;
  String? firstName;
  String? lastName;
  String? _password;
  late AuthenticationBloc authBloc;
  bool?  _switchValue;
  bool _obscureText = false;
  bool check = false;

  @override
  void initState() {
    super.initState();
    authBloc  = AuthenticationBloc();
    listenBloc();
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if(event != null){
        check = true;
        VxNavigator.of(context).push(Uri.parse('/$event'));
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
                        Space(height: 80.0),
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
                      child: Progress()));
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
              child: Text(intl.register, style: TextStyle(
                  color: AppColors.penColor,
                  fontSize: 22.0,
                  fontFamily: 'Iransans-Bold',
                  fontWeight: FontWeight.w700))
          ),
        ),
        Positioned(
          top: 60.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal('assets/images/registry/profile_logo.svg',
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
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: AppColors.arcColor),
              child: Text("+ ${args['mobile']}",textDirection: TextDirection.ltr,
                  style: TextStyle(color: AppColors.penColor))),
          SizedBox(height: 20.0),
          Container(
            height: 60.0,
            child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    labelText: intl.name,
                    labelStyle: TextStyle(color: AppColors.penColor,fontSize: 16.0),
                    errorText:
                    _validate ? intl.fillAllField : null,
                    suffixStyle: TextStyle(color: Colors.green)),
                onChanged: (txt) {
                  firstName = txt;
                }
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 60.0,
            child: TextField(
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.penColor),
                        borderRadius: BorderRadius.circular(15.0)
                    ),
                    labelText: intl.lastName,
                    labelStyle: TextStyle(color: AppColors.penColor,fontSize: 16.0),
                    errorText:
                    _validate ? intl.fillAllField : null,
                    suffixStyle: TextStyle(color: Colors.green)),
                onChanged: (txt) {
                  lastName = txt;
                }
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            height: 60.0,
            child: TextField(
              obscureText: !_obscureText,
              decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.penColor)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.penColor),
                      borderRadius: BorderRadius.circular(15.0)),
                  labelText: intl.password,
                  errorText:
                  _validate ? intl.fillAllField : null,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.penColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  labelStyle: TextStyle(color: AppColors.penColor,fontSize: 18.0)),
              onChanged: (txt) {
                _password = txt;
              },
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(intl.woman, style: TextStyle(fontSize: 14.0,color: AppColors.penColor)),
                SizedBox(width: 10.0),
                // RollingSwitch.icon(
                //   onChanged: (bool state) {
                //     _switchValue = state;
                //   },
                //   rollingInfoRight: const RollingIconInfo(
                //     icon: Icons.person,
                //     backgroundColor: Colors.pinkAccent,
                //     // text: Text('Flag'),
                //   ),
                //   rollingInfoLeft: const RollingIconInfo(
                //     icon: Icons.person,
                //     // text: Text('Check'),
                //   ),
                // ),
                ToggleSwitch(
                  minWidth: 90.0,
                  minHeight: 45.0,
                  initialLabelIndex: 0,
                  cornerRadius: 25.0,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  totalSwitches: 2,
                  icons: [
                    Icons.person,
                    Icons.person_outline,
                  ],
                  iconSize: 30.0,
                  activeBgColors: [[Colors.red, Colors.pinkAccent], [Color(0xff3b5998), Color(0xff8b9dc3)]],
                  animate: true, // with just animate set to true, default curve = Curves.easeIn
                  curve: Curves.bounceInOut, // animate must be set to true when using custom curve
                  onToggle: (index) {
                    index == gender.man.index
                        ?_switchValue = true
                        : _switchValue = false;
                  },
                ),
                SizedBox(width: 10.0),
                Text(intl.man, style: TextStyle(fontSize: 14.0,
                    color: AppColors.penColor)),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          button(AppColors.btnColor, intl.register,Size(100.w,8.h),
                  () {
                    setState(() {
                      _text.text.isEmpty ? _validate = true : _validate = false;
                    });
                Register register = Register();
                register.firstName = firstName;
                register.lastName = lastName;
                register.mobile = args['mobile'];
                register.password = _password;
                register.gender = _switchValue;
                register.verifyCode = args['code'];
                register.countryId = args['id'];
                register.appId = '0';
                authBloc.registerMethod(register);
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
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
