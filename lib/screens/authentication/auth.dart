import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import 'authentication_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ResourcefulState<AuthScreen> {
  final _text = TextEditingController();
  String dropdownValue = 'One';
  bool _validate = false;
  late String phoneNumber;
  late String number;
  late AuthenticationBloc authBloc;
  late Country _selectedLocation;
  bool check = false;

  @override
  void initState() {
    super.initState();
    authBloc = AuthenticationBloc();
    listenBloc();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) {
      if (event != null) {
        context.vxNav.push(
          Uri(path: '/$event'),
          params: {'mobile': number, 'countryId': _selectedLocation.id},
        );
      }
    });
    authBloc.showServerError.listen((event) {
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  // StreamBuilder _dropDownMenu() {
  //   return StreamBuilder(
  //     stream: authBloc.subjectList,
  //     builder: (context, snapshot) {
  //       if (snapshot.hasError) print(snapshot.error);
  //
  //       if (snapshot.hasData) {
  //         print(snapshot.error);
  //         return Directionality(
  //           textDirection: TextDirection.ltr,
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton<Country>(
  //               isExpanded: true,
  //               icon: Icon(Icons.arrow_drop_down, color: AppColors.penColor),
  //               iconSize: 26,
  //               value: _selectedLocation = authBloc.subject,
  //               alignment: Alignment.center,
  //               onChanged: (Country? newValue) {
  //                 setState(() {
  //                   _selectedLocation = newValue!;
  //                   authBloc.setSubject(newValue);
  //                 });
  //               },
  //               items: snapshot.data
  //                   .map<DropdownMenuItem<Country>>((Country data) {
  //                 return DropdownMenuItem<Country>(
  //                     child: Padding(
  //                       padding: const EdgeInsets.only(top: 6.0),
  //                       child: Center(
  //                           child: Text("+ ${data.code}",
  //                               textAlign: TextAlign.center,
  //                               textDirection: TextDirection.ltr,
  //                               style: TextStyle(
  //                                   color: AppColors.penColor,
  //                                   fontSize: 16.0))),
  //                     ),
  //                     value: data);
  //               }).toList(),
  //             ),
  //           ),
  //         );
  //       } else {
  //         return Center(
  //             child: Container(width: 7.w, height: 7.w, child: Progress()));
  //       }
  //     },
  //   );
  // }

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
                          width: 15.w, height: 15.w, child: Progress()));
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
              Container(
                decoration: AppDecorations.boxMild.copyWith(
                  color: AppColors.box,
                ),
                width: 25.w,
                height: 8.h,
                padding: EdgeInsets.all(3.w),
                margin: EdgeInsets.only(right: 3.w),
                child: StreamBuilder(
                  stream: authBloc.selectedCountry,
                  builder: (_, AsyncSnapshot<Country> snapshot) {
                    if (snapshot.hasData)
                      return GestureDetector(
                        onTap: () => DialogUtils.showBottomSheetPage(
                          context: context,
                          child: Container(
                            height: 32.h,
                            padding: EdgeInsets.all(5.w),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                //ToDo: uncomment search box to search among countries
                                // TextField(
                                //   cursorColor: AppColors.iconsColor,
                                //   textAlign: TextAlign.start,
                                //   decoration: InputDecoration(
                                //     filled: true,
                                //     fillColor: AppColors.onPrimary,
                                //     hintText: intl.whatFoodAreYouLookingFor,
                                //     contentPadding: EdgeInsets.symmetric(
                                //         vertical: 0.5.h, horizontal: 5.w),
                                //     hintStyle: typography.caption?.apply(
                                //       color: AppColors.labelColor,
                                //     ),
                                //     enabledBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           color: AppColors.onPrimary),
                                //       borderRadius: AppBorderRadius
                                //           .borderRadiusExtraLarge,
                                //     ),
                                //     focusedBorder: OutlineInputBorder(
                                //       borderSide: BorderSide(
                                //           color: AppColors.onPrimary),
                                //       borderRadius: AppBorderRadius
                                //           .borderRadiusExtraLarge,
                                //     ),
                                //     suffixIcon: Icon(
                                //       Icons.search,
                                //       size: 10.w,
                                //       color: AppColors.iconsColor,
                                //     ),
                                //   ),
                                //   style: typography.subtitle2?.apply(
                                //     color: AppColors.onSurface.withOpacity(0.9),
                                //   ),
                                //   onChanged: (value) =>
                                //       authBloc.onCountrySearch(value),
                                // ),
                                Space(height: 2.h),
                                Expanded(
                                  child: ListView.builder(
                                    // shrinkWrap: true,
                                    itemBuilder: (_, index) => GestureDetector(
                                      onTap: () {
                                        authBloc.setCountry(
                                            authBloc.countries[index]);
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        height: 5.h,
                                        child: Directionality(
                                          textDirection: TextDirection.ltr,
                                          child: Row(
                                            children: [
                                              Text(
                                                '+${authBloc.countries[index].code}',
                                                style: typography.caption,
                                              ),
                                              Space(width: 3.w),
                                              Expanded(
                                                  child: Text(
                                                authBloc.countries[index].name ??
                                                    '',
                                                style: typography.caption,
                                              )),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    itemCount: authBloc.countries.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                '+${snapshot.requireData.code}',
                                style: typography.caption,
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.ltr,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      );
                    return Progress();
                  },
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
              if (_selectedLocation.code == '98') {
                while (phoneNumber.startsWith('0')) {
                  phoneNumber = phoneNumber.replaceFirst(RegExp(r'0'), '');
                }
                if ((phoneNumber.length) != 10) {
                  Utils.getSnackbarMessage(context, intl.errorMobileCondition);
                  return;
                }
              } else if ((_selectedLocation.code!.length + phoneNumber.length) <
                      7 ||
                  (_selectedLocation.code!.length + phoneNumber.length) > 15) {
                Utils.getSnackbarMessage(context, intl.errorMobileCondition);
                return;
              }
              number = _selectedLocation.code! + phoneNumber;
              DialogUtils.showDialogProgress(context: context);
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
