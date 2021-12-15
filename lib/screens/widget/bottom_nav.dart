import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/sizes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

enum BottomNavItem { PROFILE, SUPPORT, DIET, SHOP, STATUS }

class BottomNav extends StatefulWidget {
  final BottomNavItem currentTab;

  BottomNav({required this.currentTab});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends ResourcefulState<BottomNav> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
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
      child: bottomNavBar(),
    );
  }

  Widget item(String imageAddress, BottomNavItem type, String title, BuildContext context) {
    return GestureDetector(
      onTap: () {
        switch (type) {
          case BottomNavItem.PROFILE:
            if (widget.currentTab != BottomNavItem.PROFILE)
              navigator.routeManager.clearAndPush(Uri.parse(Routes.profile));
            break;
          case BottomNavItem.SUPPORT:
            navigator.routeManager.clearAndPush(Uri.parse(Routes.ticketMessage));
            break;
          case BottomNavItem.DIET:
            if (widget.currentTab != BottomNavItem.DIET)
              navigator.routeManager.clearAndPush(Uri.parse(Routes.listView));
            break;
          case BottomNavItem.SHOP:
            if (widget.currentTab != BottomNavItem.SHOP)
              navigator.routeManager.clearAndPush(Uri.parse(Routes.shopHome));
            break;
          case BottomNavItem.STATUS:
            if (widget.currentTab != BottomNavItem.STATUS)
              navigator.routeManager.clearAndPush(Uri.parse(Routes.statusUser));
            break;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Container(
                width: double.maxFinite,
                alignment: Alignment.center,
                padding: EdgeInsets.all(6),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Container(
                      child: ImageUtils.fromLocal(
                        imageAddress,
                        width: 3.h,
                        height: 3.h,
                        color: widget.currentTab == type ? AppColors.primary : AppColors.iconsColor,
                        fit: BoxFit.contain,
                      ),
                    ),
                    if (type == BottomNavItem.PROFILE && MemoryApp.inboxCount > 0)
                      Positioned(
                        left: 1,
                        top: 0,
                        child: Container(
                          width: 2.w,
                          height: 2.w,
                          decoration:
                              BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                        ),
                      )
                  ],
                ),
              ),
              flex: 1,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 1.w),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                color: type == widget.currentTab ? AppColors.primary : AppColors.iconsColor,
                fontSize: 10.sp,
                letterSpacing: -0.5,
                  ),
                ))
          ],
        ),
      ),
    );
  }

  Widget bottomNavBar() {
    return Row(
      textDirection: context.textDirectionOfLocaleInversed,
      children: <Widget>[
        Expanded(
            flex: 1,
            child: item('assets/images/tab/profile_menu_icon.svg', BottomNavItem.PROFILE,
                intl.profile, context)),
        Expanded(
            flex: 1,
            child: item('assets/images/tab/contact_menu_icon.svg', BottomNavItem.SUPPORT,
                intl.ticket, context)),
        Expanded(
            flex: 1,
            child: item(
                'assets/images/tab/food_menu_icon.svg', BottomNavItem.DIET, intl.diet, context)),
        Expanded(
            flex: 1,
            child: item(
                'assets/images/tab/menu_shop.svg', BottomNavItem.SHOP, intl.shopMenu, context)),
        Expanded(
            flex: 1,
            child: item('assets/images/tab/status_menu_icon.svg', BottomNavItem.STATUS, intl.status,
                context)),
      ],
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
