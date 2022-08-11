import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/screens/widget/login_background.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import 'authentication_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ResourcefulState<AuthScreen> {
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
          context.vxNav.push(Uri(path: '/$event'), params: {
            "mobile": number,
            "country": _selectedLocation
          });
        else
          context.vxNav.push(Uri(path: '/$event'), params: {
            "mobile": number,
            "country": _selectedLocation
          });
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
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: SafeArea(
          child: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return LoginBackground(
                    children: [
                      Space(height: 25.h),
                      Expanded(child: content()),
                    ],
                  );
                } else {
                  check = false;
                  return Container(height: 100.h, child: Progress());
                }
              }),
        ),
      ),
    );
  }

  Widget content() {
    return Container(
      height: 45.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(50), topLeft: Radius.circular(50)),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0, 1))
          ]),
      child: Padding(
        padding: const EdgeInsets.only(top: 40, right: 40, left: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              intl.registerLogin,
              textAlign: TextAlign.start,
              style: typography.subtitle1!.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Space(height: 1.h),
            Text(
              intl.enterCodeSent,
              textAlign: TextAlign.start,
              style: typography.caption!.copyWith(
                  fontWeight: FontWeight.w400,
                  fontSize: 10.sp
              ),
            ),
            Space(height: 3.h),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _text,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10.0)),
                      labelText: intl.phoneNumber,
                      // errorText: _validate ? intl.fillAllField : null,
                      labelStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600),
                      suffixIcon: selectCountry()),
                  onSubmitted: (String) {
                    click(_selectedLocation);
                  },
                  onChanged: (txt) {
                    phoneNumber = txt;
                  },
                ),
              ),
            ),
            Space(height: 3.h),
            StreamBuilder(
              stream: authBloc.selectedCountry,
              builder: (_, AsyncSnapshot<Country> snapshot) {
                return CustomButton(
                  AppColors.btnColor,
                  intl.login,
                  Size(100.w, 6.h),
                  () {
                    click(snapshot.requireData);
                  },
                );
              },
            ),
            Space(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget selectCountry() {
    return Container(
      width: 30.w,
      height: 7.h,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
      child: StreamBuilder(
        stream: authBloc.selectedCountry,
        builder: (_, AsyncSnapshot<Country> snapshot) {
          if (snapshot.hasData) {
            _selectedLocation = snapshot.requireData;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () => countryDialog(),
                  child: Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.keyboard_arrow_down,
                            color: Colors.orange, size: 20),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${_selectedLocation.code ?? ''}',
                            textDirection: TextDirection.ltr,
                            style: typography.caption,
                          ),
                        ),
                      ),
                      Space(width: 3.w),
                      Expanded(
                        child: ImageUtils.fromLocal(
                            'assets/images/flags/${_selectedLocation.isoCode?.toLowerCase() ?? ''}.png',
                            width: 7.w,
                            height: 7.w),
                      ),
                    ],
                  )),
            );
          }
          return Progress();
        },
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
                                    ImageUtils.fromLocal(
                                        'assets/images/flags/${filterListCountry.data![index].isoCode?.toLowerCase() ?? ''}.png',
                                        width: 5.w,
                                        height: 5.w),
                                    Space(width: 3.w),
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
