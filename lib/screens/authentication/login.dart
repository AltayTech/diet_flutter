import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:json_annotation/json_annotation.dart';

import 'package:velocity_x/velocity_x.dart';
import 'package:sizer/sizer.dart';

import 'package:behandam/screens/utility/arc.dart';

import 'authentication_bloc.dart';

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
  late String number;
  late AuthenticationBloc authBloc;
  late CountryCode _selectedLocation;
  bool check = false;

  @override
  void initState() {
    super.initState();
    MemoryApp.needRoute = false;
    authBloc = AuthenticationBloc();
    listenBloc();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if(event != null){
        context.vxNav.push(Uri(path: '/$event'), params: {'mobile': number, 'countryId': _selectedLocation.id},);
      }
    });
    authBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    authBloc.dispose();
    super.dispose();
  }

  StreamBuilder _dropDownMenu() {
    return StreamBuilder(
      stream: authBloc.subjectList,
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);

        if (snapshot.hasData) {
          print(snapshot.error);
          return Directionality(
            textDirection: TextDirection.ltr,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<CountryCode>(
                isExpanded: true,
                icon: Icon(Icons.arrow_drop_down, color: AppColors.penColor),
                iconSize: 26,
                value: _selectedLocation = authBloc.subject,
                onChanged: (CountryCode? newValue) {
                  setState(() {
                    _selectedLocation = newValue!;
                  });
                },
                items: snapshot.data
                    .map<DropdownMenuItem<CountryCode>>((CountryCode data) {
                  return DropdownMenuItem<CountryCode>(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Center(
                            child: Text("${data.name} + ${data.code}",
                                style: TextStyle(
                                    color: AppColors.penColor,
                                    fontSize: 16.0))),
                      ),
                      value: data);
                }).toList(),
              ),
            ),
          );
        } else {
          return Center(child: Container(width:7.w,height: 7.w,child: Progress()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return SingleChildScrollView(
                    child: Column(children: [
                      header(),
                      content(),
                    ]),
                  );
                } else {
                  check = false;
                  return Center(
                      child: Container(
                          width: 15.w,
                          height: 15.w,
                          child: Progress()));
                }
              })),
    );
  }

  Widget header() {
    return Stack(
      overflow: Overflow.visible,
      children: [
        RotatedBox(quarterTurns: 90, child: MyArc(diameter: 250)),
        Positioned(
          top: 0.0,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: ImageUtils.fromLocal(
            'assets/images/registry/app_logo.svg',
            width: 50.0,
            height: 50.0,
          )),
        ),
        Positioned(
          top: 60.0,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text('به اندام دکتر کرمانی',
                  style: TextStyle(
                      color: AppColors.penColor,
                      fontSize: 22.0,
                      fontFamily: 'Iransans-Bold',
                      fontWeight: FontWeight.w700))),
        ),
        Positioned(
          top: 120.0,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal(
              'assets/images/registry/profile_logo.svg',
              width: 120.0,
              height: 120.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget content() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: AppColors.arcColor),
                  child: TextField(
                    controller: _text,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.penColor),
                            borderRadius: BorderRadius.circular(15.0)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        // enabledBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.grey)),
                        labelText: intl.enterYourMobileNumber,
                        // errorText: _validate ? intl.fillAllField : null,
                        labelStyle: TextStyle(
                            color: AppColors.penColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600)),
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
                  width: 25.w,
                  height: 8.h,
                  child: _dropDownMenu(),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: button(
            AppColors.btnColor,
            intl.registerOrLogin,
            Size(100.w, 8.h),
            () {
              while (phoneNumber.startsWith('0')) {
                phoneNumber = phoneNumber.replaceFirst(RegExp(r'0'), '');
              }
              number = _selectedLocation.code!.toString() + phoneNumber;
              authBloc.loginMethod(number);
            },
          ),
        ),
      ],
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
