import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/CustomCurve.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/my_drop_down.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sizer/sizer.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen();

  @override
  State createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ResourcefulState<EditProfileScreen> {
  late ProfileBloc profileBloc;
  UserInformation? userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc = ProfileBloc();

    /* profileBloc.showServerError.listen((event) {

    });*/
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProfileProvider(profileBloc,
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: Toolbar(titleBar: intl.profile),
            body: body(),
          ),
        ));
  }

  Widget body() {
    return Container(
      height: 100.h,
      child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Container(
                  child: StreamBuilder(
                      stream: profileBloc.progressNetwork,
                      builder: (context, snapshot) {
                        if (snapshot.data != null && snapshot.data == true ||
                            profileBloc.isProgressNetwork == null) {
                          return Center(
                            child: SpinKitCircle(
                              size: 5.h,
                              color: AppColors.primary,
                            ),
                          );
                        } else {
                          userInfo = profileBloc.userInfo;
                          return StreamBuilder(
                            stream: profileBloc.userInformationStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return content();
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.h,
                                    color: AppColors.primary,
                                  ),
                                );
                              }
                            },
                          );
                        }
                      })),
              flex: 1,
            ),
            BottomNav(
              currentTab: BottomNavItem.PROFILE,
            )
          ]),
    );
  }

  Widget content() {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
                height: 18.h,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        height: 18.h,
                        color: Colors.transparent,
                        child: ClipPath(
                          clipper: CustomCurve(),
                          child: Container(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            Container(
              padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 2.h, bottom: 2.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                textDirection: context.textDirectionOfLocale,
                children: <Widget>[
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.firstName = val),
                      value: userInfo!.firstName,
                      label: intl.name,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.lastName = val),
                      value: userInfo!.lastName,
                      label: intl.lastName,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.email = val),
                      value: userInfo!.email,
                      label: intl.email,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.multiline,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.address?.address = val),
                      value: userInfo!.address?.address,
                      label: intl.address,
                      maxLine: true,
                      ctx: context,
                      action: TextInputAction.newline,
                      formatter: null,
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.callNumber = val),
                      value: userInfo!.callNumber,
                      label: intl.callNumber,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: null,
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) =>
                          setState(() {
                            userInfo!.whatsApp = val;
                            userInfo!.socialMedia![0].pivot!.link=val;
                          }),
                      value: userInfo!.whatsAppNumber,
                      label: intl.whatsApp,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: null,
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.text,
                      validation: (val) {},
                      onChanged: (val) =>
                          setState(() {
                            userInfo!.skype = val;
                            userInfo!.socialMedia![2].pivot!.link=val;
                          }),
                      value: userInfo!.skypeAccount,
                      label: intl.skype,
                      maxLine: false,
                      ctx: context,
                      action: TextInputAction.next,
                      formatter: null,
                      textDirection: context.textDirectionOfLocale),
                  textInput(
                      height: 8.h,
                      textInputType: TextInputType.multiline,
                      validation: (val) {},
                      onChanged: (val) => setState(() => userInfo!.address?.zipCode = val),
                      value: userInfo!.address?.zipCode,
                      label: intl.zipCode,
                      maxLine: true,
                      ctx: context,
                      action: TextInputAction.newline,
                      formatter: null,
                      textDirection: context.textDirectionOfLocale),
                  SizedBox(height: 3.h),
                 /* MyDropdown(
                    value: _country,
                    hint: 'کشور',
                    widthSpace: _widthSpace,
                    list: countries,
                    onChange: (val) => setState(() {
                      _country = val;
                      print('country $val / $_country');
                    }),
                    border: true,
                  ),*/
                  /*


                        SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        MyDropdown(
                          value: _country,
                          hint: 'کشور',
                          widthSpace: _widthSpace,
                          list: countries,
                          onChange: (val) => setState(() {
                            _country = val;
                            print('country $val / $_country');
                          }),
                          border: true,
                        ),
                        SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        if (_country == 'Iran')
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(245, 245, 245, 1),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 164, 164, 164),
                                    width: SizeConfig.blockSizeHorizontal * .3,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: SizeConfig.blockSizeHorizontal * .3,
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromRGBO(180, 180, 180, 1),
                                size: SizeConfig.blockSizeHorizontal * 7,
                              ),
                              isExpanded: true,
                              value: _provice ?? null,
                              hint: Text(
                                'استان',
                                style: TextStyle(
                                  color: Color.fromRGBO(162, 160, 160, 1),
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              items: provinces
                                  .map(
                                    (item) => DropdownMenuItem(
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        item.name,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          color: Color.fromRGBO(162, 160, 160, 1),
                                          fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  value: item.name,
                                ),
                              )
                                  .toList(),
                              onChanged: (val) {
                                setState(() => _provice = val);
                                changeProvinceCity();
                              },
                            ),
                          ),
                        if (_country == 'Iran')
                          SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        if (_country == 'Iran')
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: DropdownButtonFormField(
                              decoration: InputDecoration(
                                fillColor: Color.fromRGBO(245, 245, 245, 1),
                                filled: true,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 164, 164, 164),
                                    width: SizeConfig.blockSizeHorizontal * .3,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).primaryColor,
                                    width: SizeConfig.blockSizeHorizontal * .3,
                                  ),
                                ),
                              ),
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Color.fromRGBO(180, 180, 180, 1),
                                size: SizeConfig.blockSizeHorizontal * 7,
                              ),
                              isExpanded: true,
                              value: _city ?? null,
                              hint: Text(
                                'شهر',
                                style: TextStyle(
                                  color: Color.fromRGBO(162, 160, 160, 1),
                                  fontSize: SizeConfig.blockSizeHorizontal * 4,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              items: relatedCities
                                  .map(
                                    (item) => DropdownMenuItem(
                                  child: Container(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                        item.name,
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          color: Color.fromRGBO(162, 160, 160, 1),
                                          fontSize:
                                          SizeConfig.blockSizeHorizontal * 4,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                  value: item.name,
                                ),
                              )
                                  .toList(),
                              onChanged: (val) => setState(() => _city = val),
                            ),
                          ),
                        if (_country == 'Iran')
                          SizedBox(height: SizeConfig.blockSizeVertical * 3),
                        */ /*genderBox(
                                      _widthSpace,
                                      _selectedGender,
                                      () => setState(() {
                                        if (_selectedGender != 1)
                                          _selectedGender = 1;
                                      }),
                                      () => setState(() {
                                        if (_selectedGender != 0)
                                          _selectedGender = 0;
                                      }),
                                    ),
                                    SizedBox(
                                        height: SizeConfig.blockSizeVertical * 3),*/ /*
                        greenButton(_widthSpace * 0.13, _widthSpace, () async {
                          print('selected country ${findCountryId(_country)}');
                          if (_firstname.isNotEmpty &&
                              _lastname.isNotEmpty &&
                              _country.isNotEmpty &&
                              _selectedGender != -1
//                                          _adrs != null &&
//                                          _adrs.length > 0 &&
//                                          _provice != null &&
//                                          _provice.length > 0 &&
//                                          _city != null &&
//                                          _city.length > 0
                          ) {
                            showLoaderDialog(context, SizeConfig.blockSizeHorizontal);
                            var userSample = User(
                                firstname: _firstname,
                                lastname: _lastname,
                                gender: _selectedGender,
                                email: _email,
                                avatar: null,
                                address: _adrs,
                                zipCode: _zipcode,
                                countryId: findCountryId(_country),
                                provinceId: findProvinceId(_provice),
                                cityId: findCityId(_city),
                                whatsApp: _whats,
                                callNumber: _callNumber,
                                telegram: null,
                                skype: _skype,
                                birthDate: user.birthDate,
                                isBehandam3User: user.isBehandam3User,
                                hasFitaminService: user.hasFitaminService,
                                has_call: user.has_call,
                                is_certification_quiz_enabled: user.is_certification_quiz_enabled);
                            print('edit $_callNumber // ${userSample.toJson()}');
                            try {
                              result = await _profileService.updateUserProfile(
                                  userSample,
                                  EditProfile.routeName
                                      .substring(1, EditProfile.routeName.length));
                              print('edit profile result $result');
                              Navigator.of(context).pop();
                              if (result != null &&
                                  result['statusCode'] >= 200 &&
                                  result['statusCode'] <= 209) {
                                user = userSample;
                                saveOnSharedPreferences(null, userSample, null);
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    UserProfile.routeName, (route) => false);
                              } else {
                                showSnackbar(setErrorMessage(result),
                                    SizeConfig.blockSizeHorizontal, true, _scaffoldKey);
                              }
                            } catch (e) {
                              // Navigator.of(context).pop();
                              if (e == 'مجددا وارد برنامه شوید')
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    LaunchRoute.routeName, (route) => false);
                              else {
                                print('status error $e');
                                FirebaseCrashlytics.instance.recordError(e, null,
                                    reason: 'edit profile picture');
                                FirebaseCrashlytics.instance
                                    .setUserIdentifier(user.mobile);
                                FirebaseCrashlytics.instance.log(token);
                                showSnackbar(setErrorMessage(result),
                                    SizeConfig.blockSizeHorizontal, true, _scaffoldKey);
                              }
                            }
                          }
                        }, false, Color.fromRGBO(74, 202, 150, 1), 'ثبت تغییرات', 2,
                            Colors.white, Colors.white),
                        SizedBox(height: SizeConfig.blockSizeVertical * 3),*/
                  // SizedBox(height: 2.h),
                ],
              ),
            )
          ],
        ),
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget exitButton() {
    return GestureDetector(
      onTap: () async {
        // user.clearUser();
        // user = null;
        // _emptySharedPreferences();
//                                               Navigator.pushNamedAndRemoveUntil(
//                                                   context, LaunchRoute.routeName, (route) => false);
// //
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: AppColors.onPrimary,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowColor,
              spreadRadius: 7.0,
              blurRadius: 12.0,
            ),
          ],
        ),
        width: double.infinity,
        height: 7.h,
        child: Center(
          child: Text(
            intl.exit,
            textAlign: TextAlign.center,
            style: Theme
                .of(context)
                .textTheme
                .button!
                .copyWith(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ),
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
}
