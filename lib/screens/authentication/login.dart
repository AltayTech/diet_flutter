import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../helper/Arc.dart';

import 'lgnReg_bloc.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ResourcefulState<LoginScreen> {
  final _text = TextEditingController();
  String dropdownValue = 'One';
  bool _validate = false;
  late String phoneNumber;
  late  String number;
  late LoginRegisterBloc loginBloc;
  late CountryCode _selectedLocation;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loginBloc  = LoginRegisterBloc();
    listenBloc();
  }

  void listenBloc() {
    loginBloc.navigateToVerify.listen((event) {
      try {
        if ((event as bool)) {
          VxNavigator.of(context).push(Uri.parse(Routes.pass), params: number);
          // Navigator.pushNamed(context, Routes.pass, arguments: phoneNumber);
        } else {
          navigator.routeManager.push(Uri.parse(Routes.verify),params: {'mobile' : number, 'countryId': _selectedLocation.id});
        }
      }catch(e){
        print('e ==> ${e.toString()}');
      }
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

  StreamBuilder _dropDownMenu() {
    return StreamBuilder(
      stream: loginBloc.subjectList,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if (snapshot.hasData) {
          print(snapshot.error);
          return DropdownButtonHideUnderline(
            child: DropdownButton<CountryCode>(
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 22,
              // elevation: 6,
              style: TextStyle(color: Colors.black),
              value: _selectedLocation = loginBloc.subject,
              onChanged: (CountryCode? newValue) {
                setState(() {
                  _selectedLocation = newValue!;
                });
              },
              items: snapshot.data.map<DropdownMenuItem<CountryCode>>((CountryCode data) {
                return DropdownMenuItem<CountryCode>(
                  child: Center(child: Text(" ${data.code} +  ${data.name}",style: TextStyle(fontSize: 12.0),)),
                  value: data,
                );
              }).toList(),
            ),
          );
        } else {
          return CircularProgressIndicator(color: Colors.grey,strokeWidth: 1.0);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            child: Column(children: [
        Stack(
            overflow: Overflow.visible,
            children: [
              RotatedBox(quarterTurns: 90, child: MyArc(diameter: 250)),
              Positioned(
                top: 40.0,
                right: 0.0,
                left: 0.0,
                child: Center(
                    child: Text('به اندام دکتر کرمانی', style: TextStyle(fontSize: 22.0,fontFamily: 'Iransans-Bold'))
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
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Flexible(
                      child: Container(
                        color: Color(0xfff5f5f5),
                        // width: 300.0,
                        child: TextField(
                          controller: _text,
                          decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(15.0)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              // enabledBorder: OutlineInputBorder(
                              //   borderSide: BorderSide(color: Colors.grey)),
                              labelText: 'شماره موبایلت رو وارد کن',
                              labelStyle: TextStyle(color: Color(0xff191C32),fontSize: 16.0),
                              errorText:
                              _validate ? 'Username Can\'t Be Empty' : null),
                          onChanged: (txt) {
                            phoneNumber = txt;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xF6F5F5F5),
                        ),
                        width:100,
                        height: 60.0,
                        child:Padding(padding:EdgeInsets.only(right: 15.0),child: _dropDownMenu()),),
                    )

                  ],
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
                        child: Text('ثبت نام و ورود',style: TextStyle(fontSize: 22.0),),
                        onPressed: () async {
                          while (phoneNumber.startsWith('0')) {
                            phoneNumber = phoneNumber.replaceFirst(RegExp(r'0'), '');
                          }
                          number = _selectedLocation.code! +
                              phoneNumber;
                          loginBloc.loginMethod(number);
                          setState(() {
                            _text.text.isEmpty ? _validate = true : _validate = false;
                          });
                          // VxNavigator.of(context).push(Uri.parse(Routes.pass));
                        }).p(20);
                  }
              ),
      ]),
          )),
    );
  }
}
