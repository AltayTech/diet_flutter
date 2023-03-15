import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/profile/toolbar_profile.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/screens/widget/cross_item_profile.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';

import 'package:behandam/themes/colors.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen();

  @override
  State createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ResourcefulState<ProfileScreen> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    profileBloc = ProfileBloc();
    getlistCountry();
    listenBloc();
  }

  void getlistCountry() async {
    List<picker.Country> list = await picker.getCountries(context);
    profileBloc.getInformation(list);
  }

  void listenBloc() {
    profileBloc.navigateToVerify.listen((event) {
      Navigator.of(context).pop();
      if (event.contains('fitamin://')) {
        IntentUtils.openApp('com.app.fitamin');
      } else {
        _launchURL(event);
      }
    });
    profileBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  void dispose() {
    profileBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProfileProvider(profileBloc,
        child: SafeArea(
          child: Scaffold(
            body: body(),
          ),
        ));
  }

  Widget body() {
    return Container(
      height: 100.h,
      child: Stack(children: [
        Container(
            height: 80.h,
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
                    return StreamBuilder(
                      stream: profileBloc.userInformationStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: <Widget>[ ToolbarProfile(), content(),],
                          );
                        } else {
                          return Center(
                            child: Progress(),
                          );
                        }
                      },
                    );
                  }
                })),
        Positioned(
          bottom: 0,
          child: BottomNav(
            currentTab: BottomNavItem.PROFILE,
          ),
        )
      ]),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 6.h),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          textDirection: context.textDirectionOfLocale,
          children: <Widget>[

            Flexible(
              flex: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: optionUi(
                          Icons.edit, intl.editProfile, 2)),
                  Space(width: 5.w),
                  Expanded(
                      flex: 1,
                      child: optionUi(
                          Icons.lock, intl.changePassword, 0)),
                ],
              ),
            ),
            Space(height: 4.h),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 246, 246, 246),
                    spreadRadius: 7.0,
                    blurRadius: 12.0,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Expanded(
                    child: CrossItemProfile(
                      imageAddress: 'assets/images/profile/contact.svg',
                      text: intl.contactMe,
                      space: false,
                      url: 'https://drkermanidiet.com/vip/',
                      context: context,
                    ),
                    flex: 1,
                  ),
                  Container(
                    width: 1.w,
                    height: 2.h,
                    color: Color.fromARGB(255, 237, 237, 237),
                  ),
                  Expanded(
                    child: CrossItemProfile(
                      imageAddress: 'assets/images/profile/about_us.svg',
                      text: intl.aboutMe,
                      space: false,
                      context: context,
                      url: 'https://drkermanidiet.com/%d9%85%d9%86-%d9%86%d8%ad%d9%86%d8%9f/',
                    ),
                    flex: 1,
                  ),
                  Container(
                    width: 1.w,
                    height: 2.h,
                    color: Color.fromARGB(255, 237, 237, 237),
                  ),
                  Expanded(
                    child: CrossItemProfile(
                      imageAddress: 'assets/images/profile/magazine.svg',
                      text: intl.magazine,
                      space: false,
                      context: context,
                      url: 'https://drkermanidiet.com/',
                    ),
                    flex: 1,
                  ),
                ],
              ),
            ),
            Space(height: 4.h),
            SubmitButton(
              onTap: () {
                AppSharedPreferences.logout();
                VxNavigator.of(context).clearAndPush(Uri.parse(Routes.auth));
              },
              label: intl.exit,
            ),
            Space(height: 2.h),
          ],
        ),
      ),
      scrollDirection: Axis.vertical,
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
