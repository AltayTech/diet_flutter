import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/profile/profile_provider.dart';
import 'package:behandam/screens/profile/toolbar_profile.dart';
import 'package:behandam/screens/profile/tools_box.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/box_end_date_subscription.dart';
import 'package:behandam/screens/widget/cross_item_profile.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/screens/widget/widget_icon_text_progress.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
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
    profileBloc.getInformation();
    listenBloc();
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
            appBar: Toolbar(titleBar: intl.profile, elevationValue: 0),
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
        child: TouchMouseScrollable(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(right: 4.w, left: 4.w, top: 6.h),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                textDirection: context.textDirectionOfLocale,
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        BoxEndTimeSubscription(
                          time: "121",
                          mainAxisAlignment: MainAxisAlignment.start,
                        ),
                        SubmitButton(
                          onTap: () {
                            VxNavigator.of(context).push(Uri.parse(Routes.selectPackageSubscription));
                          },
                          label: intl.reviveSubscription,
                          size: Size(35.w,5.h),
                        )
                      ],
                    ),
                  ),
                  Space(height: 2.h),
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
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true)
                            return Space(height: 2.h);
                          else
                            return Container();
                        },
                        stream: profileBloc.showRefund,
                      ),
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true)
                            return WidgetIconTextProgress(
                                countShow: false,
                                title: intl.requestBackPayment,
                                listIcon: 'assets/images/diet/dollar_symbol.svg',
                                index: 3);
                          else
                            return Container();
                        },
                        stream: profileBloc.showRefund,
                      ),
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data == true)
                            return Space(height: 2.h);
                          else
                            return Container();
                        },
                        stream: profileBloc.showPdf,
                      ),
                      StreamBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.requireData == true)
                            return WidgetIconTextProgress(
                                countShow: false,
                                title: intl.getPdfTerm,
                                listIcon: 'assets/images/foodlist/share/downloadPdf.svg',
                                index: 2);
                          else
                            return Container();
                        },
                        stream: profileBloc.showPdf,
                      ),
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
                  SubmitButton(
                    onTap: () {
                      profileBloc.logOut();
                    },
                    label: intl.exit,
                  ),
                  Space(height: 2.h),
                ],
              ),
            ),
            scrollDirection: Axis.vertical,
          ),
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
              onTap: () {
                DialogUtils.showDialogProgress(context: context);
                profileBloc.checkFitamin();
              },
              child: cardLeftOrRightColor(
                  'assets/images/profile/box_blue_bg.svg',
                  'assets/images/profile/fitamin.svg',
                  intl.mySportProgram,
                  Color(0xff66D4C9),
                  Color.fromARGB(255, 243, 233, 248),
                  context.textDirectionOfLocale,
                  context.isRtl),
            ),
          ),
        if (profileBloc.userInfo != null &&
            (profileBloc.userInfo.hasFitaminService != null &&
                profileBloc.userInfo.hasFitaminService!))
          Space(height: 3.h),
      ],
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {

  }

  @override
  void onRetryLoadingPage() {
    profileBloc.getInformation();
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
