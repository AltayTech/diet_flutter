import 'dart:async';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/screens/vitrin/vitrin_bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:installed_apps/installed_apps.dart';

import '../../routes.dart';

class VitrinScreen extends StatefulWidget {
  const VitrinScreen({Key? key}) : super(key: key);

  @override
  State<VitrinScreen> createState() => _VitrinScreenState();
}

class _VitrinScreenState extends ResourcefulState<VitrinScreen> {
  late VitrinBloc vitrinBloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    vitrinBloc = VitrinBloc();
    listenBloc();
  }

  void listenBloc() {
    vitrinBloc.navigateToVerify.listen((event) {
      if ((event as bool)) {
        LaunchApp.openApp(
          androidPackageName: 'com.app.fitamin',
          // iosUrlScheme: 'pulsesecure://',
          // appStoreLink: 'itms-apps://itunes.apple.com/us/app/pulse-secure/id945832041',
          // openStore: false
        );
      } else {
        _launchURL('https://app.fitamin.ir/register');
      }
    });
    vitrinBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: AppColors.redBar,
            title: Text(intl.behandam, textAlign: TextAlign.center)),
        body: Container(
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          InkWell(
                              onTap: () => VxNavigator.of(context)
                                  .push(Uri.parse(Routes.bodyState)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: ImageUtils.fromLocal(
                                    'assets/images/vitrin/dr1.jpg',
                                    width: 100.w,
                                    fit: BoxFit.fill,
                                    height: 15.h),
                              )),
                          SizedBox(height: 2.h),
                          InkWell(
                              onTap: () => VxNavigator.of(context)
                                  .push(Uri.parse(Routes.psychologyIntro)),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: ImageUtils.fromLocal(
                                    'assets/images/vitrin/dr2.jpg',
                                    width: 100.w,
                                    fit: BoxFit.fill,
                                    height: 15.h),
                              )),
                          SizedBox(height: 2.h),
                          InkWell(
                              onTap: () => _launchURL('https://kermany.com'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: ImageUtils.fromLocal(
                                    'assets/images/vitrin/dr3.jpg',
                                    width: 100.w,
                                    fit: BoxFit.fill,
                                    height: 15.h),
                              )),
                          SizedBox(height: 2.h),
                          InkWell(
                              onTap: () => _launchURL(
                                  'https://www.instagram.com/accounts/login/?next=/drkermany/'),
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(16)),
                                child: ImageUtils.fromLocal(
                                    'assets/images/vitrin/dr4.png',
                                    width: 100.w,
                                    fit: BoxFit.fill,
                                    height: 15.h),
                              )),
                          SizedBox(height: 2.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
        bottomNavigationBar: BottomNav(
          currentTab: BottomNavItem.SHOP,
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
