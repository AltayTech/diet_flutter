import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

enum BottomNavItem{
  PROFILE,
  SUPPORT,
  DIET,
  VITRINE,
  STATUS
}

class BottomNav extends StatelessWidget {
  final BottomNavItem currentTab;

  BottomNav({required this.currentTab});

  Widget item(String imageAddress,BottomNavItem type, String title,BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case BottomNavItem.PROFILE:
            /*if (title != currentTab)
              Navigator.pushNamedAndRemoveUntil(context, UserProfile.routeName, (route) => false);*/
            break;
          case BottomNavItem.SUPPORT:
           // Navigator.pushNamedAndRemoveUntil(context, TicketTab.routeName, (route) => false);
            break;
          case BottomNavItem.DIET:

          /*  if (token == null) {
              Navigator.pushNamedAndRemoveUntil(context, LaunchRoute.routeName, (route) => false);
            } else if (title != currentTab && token != null) {
              // getLastPage(context);
              Navigator.pushNamedAndRemoveUntil(context, FindRoute.routeName, (route) => false);
            }*/
            break;
          case BottomNavItem.VITRINE:
           /* if (title != currentTab)
              Navigator.pushNamedAndRemoveUntil(context, HealthTools.routeName, (route) => false);
            break;*/
          case BottomNavItem.STATUS:
          /*  if (title != currentTab)
              Navigator.pushNamedAndRemoveUntil(context, Status.routeName, (route) => false);*/
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(child: Container(
              width: double.maxFinite,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SvgPicture.asset(
                    imageAddress,
                    width: 5.h,
                    height: 5.h,
                    color: BottomNavItem.PROFILE == currentTab ? Theme.of(context).primaryColor : Color(0xff646464),
                    fit: BoxFit.fitWidth,
                  ),
                  if (type == BottomNavItem.PROFILE && MemoryApp.inboxCount > 0)
                    Positioned(
                      left: 8,
                      top: 0,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      ),
                    )
                ],
              ),
            ),flex: 1,),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: type == currentTab ? Theme.of(context).primaryColor : Color(0xff646464),
                fontSize: 10.sp,
                letterSpacing: -0.5,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(0.0, 0.0),
          color: Colors.grey[300]!,
          blurRadius: 3.0,
          spreadRadius: 2.0,
        ),
      ]),
      height: AppSizes.bottomNavHeight,
      child: bottomNavBar(context),
    );
  }

  Widget bottomNavBar(context){
    return Row(
      children: <Widget>[
        Expanded(
            flex: 1, child: item('images/tab/profile_menu_icon.svg',BottomNavItem.PROFILE, 'پروفایل', context)),
        Expanded(
            flex: 1, child: item('images/tab/contact_menu_icon.svg',BottomNavItem.SUPPORT, 'پشتیبان', context)),
       Expanded(
            flex: 1,
            child: item('images/tab/food_menu_icon.svg',BottomNavItem.DIET, 'رژیم', context)),
        Expanded(
            flex: 1, child: item('images/tab/tools_menu_icon.svg',BottomNavItem.VITRINE, 'ویترین', context)),
        Expanded(
            flex: 1, child: item('images/tab/status_menu_icon.svg',BottomNavItem.STATUS, 'وضعیت', context)),
      ],
    );
  }
}
