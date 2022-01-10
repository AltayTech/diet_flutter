import 'package:badges/badges.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/widget/custom_curve.dart';
import 'package:behandam/screens/widget/my_drop_down.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class UserBox extends StatefulWidget {
  UserBox();

  @override
  State createState() => UserBoxState();
}

class UserBoxState extends ResourcefulState<UserBox> {
  late ProfileBloc profileBloc;
  UserInformation? userInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    profileBloc = ProfileProvider.of(context);
    userInfo = profileBloc.userInfo;
    return Container(
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
              onChanged: (val) => userInfo!.firstName = val,
              value: userInfo!.firstName,
              label: intl.name,
              maxLine: false,
              enable: true,
              ctx: context,
              action: TextInputAction.next,
              formatters: [FilteringTextInputFormatter.deny(RegExp(r'[0-9]'))],
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.text,
              validation: (val) {},
              onChanged: (val) => userInfo!.lastName = val,
              value: userInfo!.lastName,
              label: intl.lastName,
              maxLine: false,
              ctx: context,
              enable: true,
              action: TextInputAction.next,
              formatters: [FilteringTextInputFormatter.deny(RegExp(r'[0-9]')),],
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.emailAddress,
              validation: (val) {},
              onChanged: (val) => userInfo!.email = val,
              value: userInfo!.email,
              label: intl.email,
              maxLine: false,
              enable: true,
              ctx: context,
              action: TextInputAction.next,
              formatters:[],
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              enable: true,
              textInputType: TextInputType.multiline,
              validation: (val) {},
              onChanged: (val) {
                if(userInfo!.address==null)
                  userInfo!.address=Address();
                userInfo!.address!.address = val;},
              value: userInfo!.address?.address,
              label: intl.address,
              maxLine: true,
              ctx: context,
              action: TextInputAction.newline,
              formatters: null,
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.number,
              validation: (val) {},
              onChanged: (val) => userInfo!.callNumber = val,
              value: userInfo!.callNumber,
              label: intl.callNumber,
              maxLine: false,
              ctx: context,
              enable: true,
              action: TextInputAction.next,
              formatters: null,
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.number,
              validation: (val) {},
              onChanged: (val) => userInfo!.socialMedia![0].pivot!.link = val,
              value: userInfo!.whatsApp,
              label: intl.whatsApp,
              enable: true,
              maxLine: false,
              ctx: context,
              action: TextInputAction.next,
              formatters: null,
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.text,
              validation: (val) {},
              enable: true,
              onChanged: (val) {

                  userInfo!.socialMedia![2].pivot!.link = val ?? '';},
              value: userInfo!.skype,
              label: intl.skype,
              maxLine: false,
              ctx: context,
              action: TextInputAction.next,
              formatters:
                  [FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),],
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          textInput(
              height: 8.h,
              textInputType: TextInputType.number,
              validation: (val) {},
              onChanged: (val) => userInfo!.address?.zipCode = val,
              value: userInfo!.address?.zipCode,
              label: intl.zipCode,
              maxLine: true,
              enable: true,
              ctx: context,
              action: TextInputAction.done,
              textDirection: context.textDirectionOfLocale),
          Space(height: 3.h),
          Directionality(
              textDirection: context.textDirectionOfLocale,
              child: MyDropdown(
                value: profileBloc.findCountryName(),
                alignment: context.isRtl
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                hint: intl.country,
                list: profileBloc.loginRegisterBloc!.countries,
                onChange: (dynamic val) => setState(() {
                  profileBloc.userInfo.countryId = val.id;
                  if (profileBloc.countryName != 'Iran') {
                    profileBloc.userInfo.cityId = null;
                    profileBloc.userInfo.provinceId = null;
                  }
                  print('country $val / $val.id');
                }),
                border: true,
              )),
          if (profileBloc.countryName == 'Iran') Space(height: 3.h),
          if (profileBloc.countryName == 'Iran')
            Directionality(
                textDirection: TextDirection.rtl,
                child: StreamBuilder(
                  stream: profileBloc.cityProvinceModelStream,
                  builder:
                      (context, AsyncSnapshot<CityProvinceModel> snapshot) {
                    if (snapshot.data != null) {
                      return MyDropdown(
                        value: profileBloc.findProvincesName(),
                        alignment: Alignment.centerRight,
                        hint: intl.province,
                        list: snapshot.data!.provinces,
                        onChange: (dynamic val) => setState(() {
                          if (profileBloc.userInfo.address == null)
                            profileBloc.userInfo.address = new Address();
                          profileBloc.userInfo.address!.provinceId = val.id;
                          print('Province ${val.id}');
                          profileBloc.changeProvinceCity();
                        }),
                        border: true,
                      );
                    } else {
                      return Container();
                    }
                  },
                )),
          if (profileBloc.countryName == 'Iran') Space(height: 3.h),
          if (profileBloc.countryName == 'Iran')
            Directionality(
              textDirection: TextDirection.rtl,
              child: StreamBuilder(
                stream: profileBloc.cityProvinceModelStream,
                builder: (context, AsyncSnapshot<CityProvinceModel> snapshot) {
                  if (snapshot.data != null &&
                      profileBloc.userInfo.address != null) {
                    return MyDropdown(
                      value: profileBloc.findCityName() ?? '',
                      alignment: Alignment.centerRight,
                      hint: intl.city,
                      list: snapshot.data?.cities ?? List.generate(0, (index) => 0),
                      onChange: (dynamic val) => setState(() {
                        profileBloc.userInfo.address!.cityId = val.id;
                        print('city $val.id');
                      }),
                      border: true,
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
        ],
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
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
