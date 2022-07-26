import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/authentication/auth_header.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'authentication_bloc.dart';

class AuthNewScreen extends StatefulWidget {
  @override
  _AuthNewScreenState createState() => _AuthNewScreenState();
}

class _AuthNewScreenState extends ResourcefulState<AuthNewScreen> {
  final _text = TextEditingController();
  final _textCountryCode = TextEditingController();
  final _textSearchCountryCode = TextEditingController();
  String dropdownValue = 'One';
  bool _validate = false;
  String? phoneNumber;
  late String number;
  late AuthenticationBloc authBloc;
  late Country _selectedLocation;
  bool check = false;

  @override
  void initState() {
    super.initState();

    authBloc = AuthenticationBloc();
    authBloc.fetchCountries();

    listenBloc();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) async {
      if (event != null) {
        if (event.toString().contains('verify'))
          context.vxNav.push(Uri(path: '/$event', queryParameters: {
            "mobile": number,
            "countryId": '${_selectedLocation.id}'
          }));
        else
          context.vxNav.push(
            Uri(path: '/$event'),
            params: {'mobile': number, 'countryId': '${_selectedLocation.id}'},
          );
      }
    });

    authBloc.showServerError.listen((event) {
      Navigator.pop(context);
    });

    authBloc.selectedCountry.listen((event) {
      _textCountryCode.text = '+${event.code}';
    });
  }

  @override
  void dispose() {
    authBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(body: body());
  }

  Widget body() {
    return SafeArea(
      child: StreamBuilder(
          stream: authBloc.waiting,
          builder: (context, snapshot) {
            if (snapshot.data == false && !check) {
              return Container(
                width: double.infinity,
                height: 100.h,
                decoration: BoxDecoration(
                    image: ImageUtils.decorationImage(
                        "assets/images/app_background.png")),
                child: Column(children: [
                  Space(height: 10.h),
                  showLogo(),
                  Space(height: 25.h),
                  Expanded(child: content()),
                ]),
              );
            } else {
              check = false;
              return Container(height: 100.h, child: Progress());
            }
          }),
    );
  }

  Widget showLogo() {
    return Container(
        child: Column(children: [
      ImageUtils.fromLocal('assets/images/registry/app_logo.svg',
          width: 20.w, height: 20.w),
      Space(height: 2.h),
      Text(
        intl.appDescription,
        textAlign: TextAlign.start,
        style: typography.headline4!.copyWith(
          fontFamily: 'yekan_bold',
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
      Text(
        intl.appDescription2,
        textAlign: TextAlign.start,
        style: typography.bodyText1!.copyWith(
          fontFamily: 'yekan',
          color: Colors.black,
        ),
      )
    ]));
  }

  Widget content() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50))),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.registerLogin,
              textAlign: TextAlign.start,
              style: typography.headline6!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Space(height: 1.h),
            Text(
              intl.enterYourPhone,
              textAlign: TextAlign.start,
              style: typography.caption!.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Space(height: 5.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              textDirection: TextDirection.rtl,
              children: [
                Flexible(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: AppColors.arcColor),
                    child: TextField(
                      controller: _text,
                      textDirection: TextDirection.ltr,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: AppColors.penColor),
                              borderRadius: BorderRadius.circular(15.0)),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          // enabledBorder: OutlineInputBorder(
                          //   borderSide: BorderSide(color: Colors.grey)),
                          labelText: intl.phoneNumber,
                          // errorText: _validate ? intl.fillAllField : null,
                          labelStyle: TextStyle(
                              color: AppColors.penColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600)),
                      onSubmitted: (String) {
                        click(_selectedLocation);
                      },
                      onChanged: (txt) {
                        phoneNumber = txt;
                      },
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      color: AppColors.arcColor),
                  width: 30.w,
                  margin: EdgeInsets.only(right: 2.w),
                  child: StreamBuilder(
                    stream: authBloc.selectedCountry,
                    builder: (_, AsyncSnapshot<Country> snapshot) {
                      if (snapshot.hasData) {
                        _selectedLocation = snapshot.requireData;
                        return InkWell(
                            onTap: () => countryDialog(),
                            child: Container(
                              child: TextField(
                                controller: _textCountryCode,
                                textDirection: TextDirection.ltr,
                                keyboardType: TextInputType.phone,
                                enabled: false,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: AppColors.penColor),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  // enabledBorder: OutlineInputBorder(
                                  //   borderSide: BorderSide(color: Colors.grey)),
                                  // errorText: _validate ? intl.fillAllField : null,
                                  labelStyle: TextStyle(
                                      color: AppColors.penColor,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => countryDialog(),
                                  ),
                                ),
                                onSubmitted: (String) {
                                  click(_selectedLocation);
                                },
                              ),
                            ));
                      }
                      return Progress();
                    },
                  ),
                )
              ],
            ),
            Space(height: 3.h),
            StreamBuilder(
              stream: authBloc.selectedCountry,
              builder: (_, AsyncSnapshot<Country> snapshot) {
                return button(
                  AppColors.btnColor,
                  intl.getCode,
                  Size(100.w, 6.h),
                  () {
                    click(snapshot.requireData);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  countryDialog() {
    DialogUtils.showBottomSheetPage(
      context: context,
      child: Container(
        height: 64.h,
        padding: EdgeInsets.all(3.w),
        alignment: Alignment.center,
        child: Column(
          children: [
            TextField(
              controller: _textSearchCountryCode,
              textDirection: TextDirection.ltr,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.penColor),
                    borderRadius: BorderRadius.circular(15.0)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // enabledBorder: OutlineInputBorder(
                //   borderSide: BorderSide(color: Colors.grey)),
                // errorText: _validate ? intl.fillAllField : null,
                label: Text(intl.search),
                labelStyle: TextStyle(
                    color: AppColors.penColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400),
              ),
              style: TextStyle(
                  color: AppColors.penColor,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400),
              onSubmitted: (String) {
                click(_selectedLocation);
              },
              onChanged: authBloc.searchCountry,
            ),
            Space(height: 2.h),
            StreamBuilder<List<Country>>(
                stream: authBloc.filterListCountry,
                builder: (context, filterListCountry) {
                  if (filterListCountry.hasData)
                    return Expanded(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              authBloc
                                  .setCountry(filterListCountry.data![index]);
                              _selectedLocation =
                                  filterListCountry.data![index];
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 5.h,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  children: [
                                    Text(
                                      '+${filterListCountry.data![index].code ?? ''}',
                                      style: typography.caption,
                                    ),
                                    Space(width: 3.w),
                                    Expanded(
                                        child: Text(
                                      filterListCountry.data![index].name ?? '',
                                      style: typography.caption,
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          itemCount: filterListCountry.data!.length,
                        ),
                      ),
                    );
                  return Center(child: Progress());
                }),
          ],
        ),
      ),
    );
  }

  void click(Country countryCode) {
    if (countryCode.code == '98') {
      while (phoneNumber != null && phoneNumber!.startsWith('0')) {
        phoneNumber = phoneNumber!.replaceFirst(RegExp(r'0'), '');
      }
      if (phoneNumber == null || phoneNumber!.length != 10) {
        Utils.getSnackbarMessage(context, intl.errorMobileCondition);
        return;
      }
    } else if ((countryCode.code!.length + phoneNumber!.length) < 7 ||
        (countryCode.code!.length + phoneNumber!.length) > 15) {
      Utils.getSnackbarMessage(context, intl.errorMobileCondition);
      return;
    }
    number = countryCode.code! + phoneNumber!;
    DialogUtils.showDialogProgress(context: context);
    authBloc.loginMethod(number.toEnglishDigit());
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
    authBloc.fetchCountries();
    click(_selectedLocation);
  }
}
