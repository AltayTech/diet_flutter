import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/user-info.dart';
import 'package:behandam/screens/authentication/lgnReg_bloc.dart';

import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../helper/Arc.dart';
import '../../routes.dart';

class PasswordScreen extends StatefulWidget {
  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends ResourcefulState<PasswordScreen> {
  final _text = TextEditingController();
  var args;
  bool _validate = false;
  bool _obscureText = true;
  String? _password;
  late LoginRegisterBloc loginBloc;

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

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
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
                        child: Text('به اندام دکتر کرمانی', style: TextStyle(fontSize: 22.0))
                    ),
                  ),
                  Positioned(
                    top: 120.0,
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
                padding: const EdgeInsets.only(right: 20.0,left: 20.0),
                child: Column(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(15.0),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.ArcColor),
                      child: Center(child: Text("+ $args", textDirection: TextDirection.ltr))),
                    SizedBox(height: 20.0),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                        color: Color(0xfff5f5f5)),
                      child: TextField(
                        obscureText: _obscureText,
                        controller: _text,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey)),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(15.0)),
                            labelText: 'رمز عبور',
                            labelStyle: TextStyle(color: Color(0xff191C32),fontSize: 18.0),
                            errorText:
                            _validate ? 'Username Can\'t Be Empty' : null),
                        onChanged: (txt) {
                          _password = txt;
                        },
                      ),
                    ),
                    SizedBox(height: 20.0),
                    VxLayout(
                        builder: (context, size, _){
                          return ElevatedButton(
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
                              child: Text('ورود',style: TextStyle(fontSize: 22.0),),
                              onPressed: () async {
                                // User user = User();
                                // user.mobile = widget.mobile;
                                // user.password = _password;
                                loginBloc.passwordMethod(args, _password!);
                                setState(() {
                                  _text.text.isEmpty ? _validate = true : _validate = false;
                                });
                                // VxNavigator.of(context).push(Uri.parse(Routes.pass));
                              });
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