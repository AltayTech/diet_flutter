import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/screens/utility/arc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/widgets/space.dart';
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
        context.vxNav.push(
          Uri(path: '/$event'),
          params: {'mobile': number, 'countryId': _selectedLocation.id},
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
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: StreamBuilder(
              stream: authBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.data == false && !check) {
                  return TouchMouseScrollable(
                    child: SingleChildScrollView(
                      child: SizedBox(
                        height: 100.h,
                        child: Column(children: [
                          header(),
                          content(),
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: 8, left: 5.w, right: 5.w),
                              child: RichText(
                                  textDirection: context.textDirectionOfLocale,
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: intl.termsOfUseDescription,
                                        style: Theme.of(context)
                                            .textTheme
                                            .button!
                                            .copyWith(
                                                color: AppColors.labelTextColor,
                                                decoration:
                                                    TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Utils.launchURL(FlavorConfig
                                                .instance
                                                .variables['urlTerms']);
                                          }),
                                  ])),
                            ),
                          ),
                          Space(height: 1.h),
                        ]),
                      ),
                    ),
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
        SizedBox(
            height: 40.h,
            child: MyArc(
              diameter: 100.w,
            )),
        Positioned(
          top: 2.h,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: ImageUtils.fromLocal(
            'assets/images/registry/app_logo.svg',
            width: 15.w,
            height: 15.w,
          )),
        ),
        Positioned(
          top: 11.h,
          right: 0.0,
          left: 0.0,
          child: Center(
              child: Text(intl.behandamDrKermany,
                  style: TextStyle(
                      color: AppColors.penColor,
                      fontSize: 22.0,
                      fontFamily: 'Iransans-Bold',
                      fontWeight: FontWeight.w700))),
        ),
        Positioned(
          top: 16.h,
          right: 0.0,
          left: 0.0,
          child: Center(
            child: ImageUtils.fromLocal(
              'assets/images/registry/profile_logo.svg',
              width: 25.w,
              height: 25.w,
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
                        labelText: intl.enterYourMobileNumber,
                        // errorText: _validate ? intl.fillAllField : null,
                        labelStyle: TextStyle(
                            color: AppColors.penColor,
                            fontSize: 16.0,
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
                          child: TextField(
                            controller: _textCountryCode,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.phone,
                            readOnly: true,
                            decoration: InputDecoration(
                              focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: AppColors.penColor),
                                  borderRadius: BorderRadius.circular(15.0)),
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
                          ));
                    }
                    return Progress();
                  },
                ),
              )
            ],
          ),
        ),
        Space(height: 10.h),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: StreamBuilder(
            stream: authBloc.selectedCountry,
            builder: (_, AsyncSnapshot<Country> snapshot) {
              return button(
                AppColors.btnColor,
                intl.registerOrLogin,
                Size(100.w, 8.h),
                () {
                  click(snapshot.requireData);
                },
              );
            },
          ),
        ),
      ],
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
      while (phoneNumber!.startsWith('0')) {
        phoneNumber = phoneNumber!.replaceFirst(RegExp(r'0'), '');
      }
      if ((phoneNumber!.length) != 10) {
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
    authBloc.loginMethod(number);
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
