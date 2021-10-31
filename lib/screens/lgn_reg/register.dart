import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/helper/Arc.dart';
import 'package:behandam/screens/lgn_reg/lgnReg_bloc.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:rolling_switch/rolling_switch.dart';

import '../../routes.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var args;
  String? firstName;
  String? lastName;
  String? pass;
  late LoginRegisterBloc loginBloc;
  bool?  _switchValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc  = LoginRegisterBloc();
    listenBloc();
  }

  void listenBloc() {
    loginBloc.navigateToVerify.listen((event) {
      if(event == true)
        VxNavigator.of(context).push(Uri.parse(Routes.home));
    });
    loginBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppColors.ArcColor,
          elevation: 0.0,
          leading: IconButton(icon: Icon(Icons.arrow_back_ios),
              color: Color(0xffb4babb),
              onPressed: () => VxNavigator.of(context).pop())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
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
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: AppColors.ArcColor),
                      child: Text("+ ${args['mobile']}",textDirection: TextDirection.ltr)),
                  SizedBox(height: 20.0),
                  Container(
                    height: 60.0,
                    child: TextField(
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(15.0)
                            ),
                            labelText: 'نام',
                            labelStyle: TextStyle(color: Color(0xff191C32),fontSize: 16.0),
                            // prefixIcon: Icon(
                            //   Icons.confirmation_num,
                            //   color: Color(0xff191C32)),
                            // prefixText: ' ',
                            // suffixText: 'USD',
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
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            labelText: 'نام خانوادگی',
                            labelStyle: TextStyle(color: Color(0xff191C32),fontSize: 16.0),
                            // prefixIcon: Icon(
                            //   Icons.confirmation_num,
                            //   color: Color(0xff191C32),
                            // ),
                            // prefixText: ' ',
                            // suffixText: 'USD',
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
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            labelText: 'رمز عبور',
                            labelStyle: TextStyle(color: Color(0xff191C32),fontSize: 16.0),
                            // prefixIcon: Icon(
                            //   Icons.confirmation_num,
                            //   color: Color(0xff191C32),
                            // ),
                            // prefixText: ' ',
                            // suffixText: 'USD',
                            suffixStyle: TextStyle(color: Colors.green)),
                        onChanged: (txt) {
                          pass = txt;
                        }
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('خانم هستم', style: TextStyle(fontSize: 14.0)),
                        SizedBox(width: 10.0),
                        RollingSwitch.icon(
                          onChanged: (bool state) {
                            _switchValue = state;
                          },
                          rollingInfoRight: const RollingIconInfo(
                            icon: Icons.person,
                            backgroundColor: Colors.pinkAccent,
                            // text: Text('Flag'),
                          ),
                          rollingInfoLeft: const RollingIconInfo(
                            icon: Icons.person,
                            // text: Text('Check'),
                          ),
                        ),
                        SizedBox(width: 10.0),
                        Text('آقا هستم', style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(AppColors.btnColor),
                          fixedSize: MaterialStateProperty.all(
                              Size(350.0, 60.0)),
                          // padding: MaterialStateProperty.all(
                          //     EdgeInsets.fromLTRB(50, 20, 50, 20)),
                          shape: MaterialStateProperty.all<
                              RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(color: AppColors.btnColor)))),
                      child: Text('ثبت نام', style: TextStyle(fontSize: 22.0),),
                      onPressed: () {
                        Register register = Register();
                        register.firstName = firstName;
                        register.lastName = lastName;
                        register.mobile = args['mobile'];
                        register.password = pass;
                        register.gender = _switchValue;
                        register.verifyCode = args['code'];
                        register.countryId = args['id'];
                        register.appId = '0';
                        // RestApiClient.routeName = "auth/register";
                        loginBloc.registerMethod(register);
                        // if(response?.data?.token != null)
                        //   VxNavigator.of(context).push(Uri.parse(Routes.home));
                      }
                  ),
                ],
              ),
            ),
          ],
        ),
      ));
  }
}
