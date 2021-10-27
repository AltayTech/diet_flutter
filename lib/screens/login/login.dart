import 'package:behandam/base/utils.dart';
import 'package:behandam/routes.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../helper/Arc.dart';

import 'login-bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _text = TextEditingController();
  String dropdownValue = 'One';
  bool _validate = false;
  late String phoneNumber;
 late LoginBloc loginBloc;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc  = LoginBloc();
    listenBloc();
  }

  void listenBloc()
  {
    loginBloc.navigateToVerify.listen((event) {
      if(event == true)
        VxNavigator.of(context).push(Uri.parse(Routes.pass));
      else
        print("there isn't such a user");
    });
    loginBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
        Stack(
            overflow: Overflow.visible,
            children: [
              RotatedBox(quarterTurns: 90, child: MyArc(diameter: 350)),
              Positioned(
                top: 50.0,
                right: 160.0,
                child: Center(
                  child: SizedBox(
                    height: 20.0,
                    width: 20.0,
                    child: CircleAvatar(
                      radius: 60.0,
                      backgroundImage: AssetImage('assets/img-01.jpg'),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 100.0,
                right: 110.0,
                child: Center(
                  child: CircleAvatar(
                    radius: 60.0,
                    backgroundImage: AssetImage('assets/img-01.jpg'),
                  ),
                ),
              ),
            ],
        ),
        Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 25.0,left: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 250.0,
                      child: TextField(
                        controller: _text,
                        decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'شماره موبایلت رو وارد کن',
                            labelStyle: TextStyle(color: Color(0xff191C32)),
                            errorText:
                                _validate ? 'Username Can\'t Be Empty' : null,
                            // prefixText: ' ',
                            // suffixText: 'USD',
                            suffixStyle: TextStyle(color: Colors.green)),
                        onChanged: (txt) {
                          phoneNumber = txt;
                        },
                      ),
                    ),
                    DropdownButton(
                        icon: Icon(Icons.arrow_drop_down),
                        value: dropdownValue,
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                        items: <String>['One', 'Two', 'Free', 'Four']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Color(0xff191C32)),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.fromLTRB(50, 20, 50, 20)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              side: BorderSide(color: Color(0xff191C32))))),
                  child: Text('ثبت نام و ورود'),
                  onPressed: () async {
                    loginBloc.loginMethod(phoneNumber);
                    setState(() {
                      _text.text.isEmpty ? _validate = true : _validate = false;
                    });
                    // VxNavigator.of(context).push(Uri.parse(Routes.pass));
                  }),
            ],
        )
      ]),
          )),
    );
  }
}
