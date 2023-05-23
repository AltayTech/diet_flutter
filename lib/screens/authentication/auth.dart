import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/widget/custom_button.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';

import 'package:velocity_x/velocity_x.dart';

import 'authentication_bloc.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends ResourcefulState<AuthScreen> {
  final _text = TextEditingController();
  final _textSearchCountryCode = TextEditingController();
  final _textCountryCode = TextEditingController();
  String dropdownValue = 'One';
  late String myGeo;
  bool _validate = false;
  late String phoneNumber;
  late String number;
  late AuthenticationBloc authBloc;
  Country? _selectedLocation;
  bool check = false;

  @override
  void initState() {
    super.initState();

    authBloc = AuthenticationBloc();
    getlistCountry();
    listenBloc();
  }

  void getlistCountry() async {
    List<picker.Country> list = await picker.getCountries(context);
    authBloc.setListCountry(list);
    authBloc.fetchCountries();
  }

  void findCountryCodeByIp() async {
    final geo = await Ipify.geo('at_5GgRPPGVt1ya5sUIHp35cieN97IvN').then((value) {
      myGeo = value.location?.country ?? 'KW';
      Country country = authBloc.findCountryByIp(myGeo);
      authBloc.setCountry(country);
      _selectedLocation = country;
    }).onError((error, stackTrace) {
      myGeo = 'KW';
      Country country = authBloc.findCountryByIp(myGeo);
      authBloc.setCountry(country);
      _selectedLocation = country;
    });
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) async {
      if (event != null) {
        context.vxNav.push(
          Uri(path: '/$event'),
          params: {'mobile': number, 'countryId': _selectedLocation?.id},
        );
      }
    });

    authBloc.navigateTo.listen((event) {
      context.vxNav.clearAndPush(Uri.parse(Routes.userCrm));
    });

    authBloc.showServerError.listen((event) {
      Navigator.pop(context);
    });

    authBloc.countriesStream.listen((event) {
      findCountryCodeByIp();
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
          body: Container(
        decoration: AppDecorations.boxNoRadius.copyWith(
            gradient: const RadialGradient(
                colors: [Color(0xff6C98FF), Color(0xff364C80)],
                center: Alignment(0.0, 0.0),
                stops: [0.0, 1.0],
                focal: Alignment(0.0, 0.1),
                focalRadius: 0,
                radius: 1,
                tileMode: TileMode.clamp)),
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder(
            stream: authBloc.waiting,
            builder: (context, snapshot) {
              if (snapshot.data == false && !check) {
                return SingleChildScrollView(
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Space(
                          height: 15.h,
                        ),
                        header(),
                        content(),
                      ]),
                );
              } else {
                check = false;
                return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
              }
            }),
      )),
    );
  }

  Widget header() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtils.fromLocal(
            'assets/images/logo_app.svg',
            width: 250,
            height: 250,
          ),
          Space(
            height: 2.h,
          ),
          Text(
            intl.appNameSplash,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _text,
                    textDirection: TextDirection.ltr,
                    keyboardType: TextInputType.phone,
                    style: typography.caption!.copyWith(color: Color(0xff454545)),
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
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
                        hintText: intl.mobile,
                        // errorText: _validate ? intl.fillAllField : null,
                        hintStyle: TextStyle(
                            color: AppColors.primary, fontSize: 12.sp, fontWeight: FontWeight.w500),
                        suffixIcon: selectCountry(),
                        suffixIconConstraints: BoxConstraints(maxWidth: 20.w, minWidth: 10.w)),
                    onSubmitted: (String) {
                      click(_selectedLocation!);
                    },
                    onChanged: (txt) {
                      phoneNumber = txt;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30.0),
          child: StreamBuilder(
            stream: authBloc.selectedCountry,
            builder: (_, AsyncSnapshot<Country> snapshot) {
              return CustomButton(
                Colors.white,
                AppColors.primary,
                intl.registerOrLogin,
                Size(100.w, 7.h),
                () {
                  if (phoneNumber.isNotEmpty) {
                    if (phoneNumber.startsWith('0')) {
                      while (phoneNumber.startsWith('0')) {
                        phoneNumber = phoneNumber.replaceFirst(RegExp(r'0'), '');
                      }
                    } else if ((snapshot.requireData.code!.length + phoneNumber.length) < 7 ||
                        (snapshot.requireData.code!.length + phoneNumber.length) > 15) {
                      Utils.getSnackbarMessage(context, intl.errorMobileCondition);
                      return;
                    }
                    number = snapshot.requireData.code! + phoneNumber;
                    DialogUtils.showDialogProgress(context: context);
                    authBloc.loginMethod(number);
                  } else {}
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget selectCountry() {
    return Container(
      height: 7.h,
      margin: EdgeInsets.only(right: 8),
      decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(10), topLeft: Radius.circular(10)),
          color: const Color.fromRGBO(255, 255, 255, 0.1),
          border: Border(right: BorderSide.none)),
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Expanded(
                        flex: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: ImageUtils.fromLocal(_selectedLocation?.flag ?? '',
                              width: 6.w,
                              package: picker.countryCodePackageName,
                              height: 6.w,
                              fit: BoxFit.fill),
                        ),
                      ),
                      const Spacer(),
                      const Expanded(
                        flex: 0,
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.grey, size: 20),
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
                    color: AppColors.penColor, fontSize: 10.sp, fontWeight: FontWeight.w400),
              ),
              style: TextStyle(
                  color: AppColors.penColor, fontSize: 10.sp, fontWeight: FontWeight.w400),
              onChanged: authBloc.searchCountry,
            ),
            Space(height: 2.h),
            StreamBuilder<List<Country>>(
                stream: authBloc.filterListCountry,
                builder: (context, filterListCountry) {
                  if (filterListCountry.hasData) {
                    return Expanded(
                      child: ScrollConfiguration(
                        behavior: MyCustomScrollBehavior(),
                        child: ListView.builder(
                          // shrinkWrap: true,
                          itemBuilder: (_, index) => GestureDetector(
                            onTap: () {
                              authBloc.setCountry(filterListCountry.data![index]);
                              _selectedLocation = filterListCountry.data![index];
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 5.h,
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (filterListCountry.data![index].flag != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(2.0),
                                        child: ImageUtils.fromLocal(
                                            filterListCountry.data![index].flag!,
                                            package: picker.countryCodePackageName,
                                            width: 7.w,
                                            fit: BoxFit.fill,
                                            height: 5.w),
                                      ),
                                    Space(width: 2.w),
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
                  }
                  return Center(child: Progress());
                }),
          ],
        ),
      ),
    );
  }

  void click(Country countryCode) {
    if (phoneNumber.startsWith('0')) {
      while (phoneNumber != null && phoneNumber.startsWith('0')) {
        phoneNumber = phoneNumber.replaceFirst(RegExp(r'0'), '');
      }
      if (phoneNumber == null) {
        Utils.getSnackbarMessage(context, intl.errorMobileCondition);
        return;
      }
    } else if ((countryCode.code!.length + phoneNumber.length) < 7 ||
        (countryCode.code!.length + phoneNumber.length) > 15) {
      Utils.getSnackbarMessage(context, intl.errorMobileCondition);
      return;
    }
    number = countryCode.code! + phoneNumber;
    DialogUtils.showDialogProgress(context: context);
    authBloc.loginMethod(number.toEnglishDigit());
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
