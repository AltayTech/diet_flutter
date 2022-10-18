import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/login_background.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/web_scroll.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../authentication_bloc.dart';

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
    getlistCountry();

    listenBloc();
  }

  void getlistCountry() async {
    List<picker.Country> list = await picker.getCountries(context);
    authBloc.setListCountry(list);
    authBloc.fetchCountries();
  }

  void listenBloc() {
    authBloc.navigateToVerify.listen((event) async {
      if (event != null) {
        if (event.toString().contains('verify'))
          context.vxNav
              .push(Uri(path: '/$event'), params: {"mobile": number, "country": _selectedLocation});
        else
          context.vxNav
              .push(Uri(path: '/$event'), params: {"mobile": number, "country": _selectedLocation});
      }
    });

    authBloc.popDialog.listen((event) {
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
                      content(),
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
      width: 100.w,
      height: 45.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.only(topRight: Radius.circular(50), topLeft: Radius.circular(50)),
      ),
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
              intl.enterYourMobileNumber,
              textAlign: TextAlign.start,
              style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
            ),
            Space(height: 3.h),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _text,
                  textDirection: TextDirection.ltr,
                  keyboardType: TextInputType.phone,
                  style: typography.caption!.copyWith(color: Color(0xff454545)),
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
                          color: Colors.grey, fontSize: 12.sp, fontWeight: FontWeight.w500),
                      suffixIcon: selectCountry(),
                      suffixIconConstraints: BoxConstraints(maxWidth: 34.w, minWidth: 25.w)),
                  onSubmitted: (String) {
                    click(_selectedLocation);
                  },
                  onChanged: (txt) {
                    phoneNumber = txt;
                  },
                ),
              ),
            ),
            Space(height: 5.h),
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
      height: 7.h,
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.grey[200]),
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
                        child: Icon(Icons.keyboard_arrow_down, color: Colors.orange, size: 20),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            '+${_selectedLocation.code ?? ''}',
                            textDirection: TextDirection.ltr,
                            maxLines: 1,
                            style: typography.caption,
                          ),
                        ),
                      ),
                      Space(width: 2.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.0),
                        child: ImageUtils.fromLocal(_selectedLocation.flag ?? '',
                            width: 6.w,
                            package: picker.countryCodePackageName,
                            height: 4.5.w,
                            fit: BoxFit.fill),
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
                  if (filterListCountry.hasData)
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
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    authBloc.setRepository();

    authBloc.fetchCountries();
    click(_selectedLocation);
  }

  @override
  void onRetryAfterNoInternet() {
    //if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    //bloc.onRetryAfterNoInternet();
  }
}
