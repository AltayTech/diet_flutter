import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/tools_box.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/profile/toolbar_profile.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/cross_item_profile.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/screens/widget/widget_icon_text_progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
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
    // TODO: implement initState
    super.initState();
    profileBloc = ProfileBloc();
    profileBloc.getInformation();
    /* profileBloc.showServerError.listen((event) {

    });*/
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProfileProvider(profileBloc,
        child: SafeArea(
          child: Scaffold(
            appBar: Toolbar(titleBar: intl.profile),
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
                          return Stack(
                            fit: StackFit.expand,
                            children: <Widget>[content(), ToolbarProfile()],
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
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      top: 10.h,
      child: Container(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 6.h),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              textDirection: context.textDirectionOfLocale,
              children: <Widget>[
                ToolsBox(),
                Space(height: 2.h),
                fitaminBanner(),
                attachBox(),
                Space(height: 3.h),
                Column(
                  children: <Widget>[
                    WidgetIconTextProgress(
                        countShow: false,
                        title: intl.help,
                        listIcon: 'assets/images/profile/guide.svg',
                        index: 0),
                    if (MemoryApp.token != null && profileBloc.showRefund) Space(height: 2.h),
                    if (MemoryApp.token != null && profileBloc.showRefund)
                      WidgetIconTextProgress(
                          countShow: false,
                          title: intl.requestBackPayment,
                          listIcon: 'assets/images/diet/dollar_symbol.svg',
                          index: 3),
                    if (MemoryApp.token != null && profileBloc.showPdf) Space(height: 2.h),
                    if (MemoryApp.token != null && profileBloc.showPdf)
                      WidgetIconTextProgress(
                          countShow: false,
                          title: intl.getPdfTerm,
                          listIcon: 'assets/images/foodlist/share/downloadPdf.svg',
                          index: 2),
                  ],
                ),
                Space(height: 2.h),
                // ContactAbout(),
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
                          url:
                              'https://kermany.com/%d8%aa%d9%85%d8%a7%d8%b3-%d8%a8%d8%a7-%d9%85%d8%a7/',
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
                          url:
                              'https://kermany.com/%d8%af%d8%b1%d8%a8%d8%a7%d8%b1%d9%87-%d8%af%da%a9%d8%aa%d8%b1-%da%a9%d8%b1%d9%85%d8%a7%d9%86%db%8c/',
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                ),
                Space(height: 2.h),
                exitButton(),
                Space(height: 2.h),
              ],
            ),
          ),
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }

  Widget fitaminBanner() {
    return Column(
      children: [
        if (profileBloc.userInfo != null &&
            profileBloc.userInfo.hasFitaminService != null &&
            profileBloc.userInfo.hasFitaminService!)
          Container(
            width: 70.w,
            child: GestureDetector(
              // onTap: () => getFitaminUrl(),
              child: card(
                  'assets/images/profile/box_blue_bg.svg',
                  'assets/images/profile/fitamin.svg',
                  intl.mySportProgram,
                  Color(0xff66D4C9),
                  Color.fromARGB(255, 243, 233, 248),
                  context.textDirectionOfLocale),
            ),
          ),
        if (profileBloc.userInfo != null &&
            (profileBloc.userInfo.hasFitaminService != null &&
                profileBloc.userInfo.hasFitaminService!))
          Space(height: 3.h),
      ],
    );
  }

  Widget exitButton(){
    return GestureDetector(
      onTap: () async {
    AppSharedPreferences.logout();
    VxNavigator.of(context).clearAndPush(Uri.parse(Routes.auth));
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
            style: Theme.of(context).textTheme.button!.copyWith(
                color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.w600),
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
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
