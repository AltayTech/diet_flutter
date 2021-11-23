import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class VitrinScreen extends StatelessWidget {
  const VitrinScreen({Key? key}) : super(key: key);

   _launchURL(_url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar:AppBar(
          backgroundColor: AppColors.redBar,
          title: Text('به اندام دکتر کرمانی',textAlign: TextAlign.center)),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.white
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  InkWell(
                      onTap: () => VxNavigator.of(context).push(Uri.parse(Routes.bodyState)),
                      child: ImageUtils.fromLocal('assets/images/vitrin/bmi_banner.jpg',width: 100.w,height: 15.h)),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () => VxNavigator.of(context).push(Uri.parse(Routes.PSYIntro)),
                      child: ImageUtils.fromLocal('assets/images/vitrin/psy_banner.png',width: 100.w,height: 15.h)),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () => _launchURL('https://kermany.com'),
                      child: ImageUtils.fromLocal('assets/images/vitrin/magazine_banner.jpg',width: 100.w,height: 15.h)),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () => _launchURL('https://www.instagram.com/accounts/login/?next=/drkermany/'),
                      child: ImageUtils.fromLocal('assets/images/vitrin/instagram_banner.jpg',width: 100.w,height: 15.h)),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () => _launchURL('https://t.me/drkermany'),
                      child: ImageUtils.fromLocal('assets/images/vitrin/telegram_banner.jpg',width: 100.w,height: 15.h)),
                  SizedBox(height: 2.h),
                  InkWell(
                      onTap: () => _launchURL('https://app.fitamin.ir/register'),
                      child: ImageUtils.fromLocal('assets/images/vitrin/fitamin_banner.png',width: 100.w,height: 15.h)),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentTab: BottomNavItem.VITRINE,
      ),
    ));
  }
}
