import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/screens/food_list/appbar_box_advice_video.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/change_menu.dart';
import 'package:behandam/screens/food_list/food_list_appbar.dart';
import 'package:behandam/screens/food_list/food_meals.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/food_list/week_day.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends ResourcefulState<FoodListPage> {
  late FoodListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = FoodListBloc(true);
    initListener();
  }

  void initListener() {
    bloc.showServerError.listen((event) {
      if (event.contains('payment/bill')) {
        context.vxNav
            .clearAndPush(Uri.parse('/${event.toString().split('/')[0]}${Routes.regimeType}'));
      } else if (!Routes.listView.contains(event)) {
        context.vxNav.clearAndPush(Uri.parse('/$event'));
      } else
        context.vxNav.replace(Uri.parse('/$event'));
    });
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FoodListProvider(
      bloc,
      child: Scaffold(
        body: SafeArea(child: body()),
      ),
    );
  }

  Widget body() {
    return StreamBuilder(
      stream: bloc.loadingContent,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: 100.h,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          FoodListAppbar(),
                          AppbarBoxAdviceVideo(),
                        ],
                      ),
                      Space(height: 2.h),
                      ChangeMenu(),
                      Space(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: FoodMeals(),
                      ),
                      Space(
                        height: 1.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(16.0)),
                          child: InkWell(
                              onTap: () {
                                DialogUtils.showDialogProgress(context: context);
                                bloc.checkFitamin();
                                // _launchURL(vitrinBloc.url);
                              },
                              child: ImageUtils.fromLocal(
                                MemoryApp.userInformation!.hasFitaminService.isNullOrFalse
                                    ? 'assets/images/vitrin/fitamin_banner.png'
                                    : 'assets/images/vitrin/fitamin_banner_02.png',
                              )),
                        ),
                      ),
                      Space(
                        height: 2.h,
                      ),
                    ],
                  ),
                ),
              ),
              BottomNav(currentTab: BottomNavItem.DIET),
            ],
          ),
        );
      },
    );
  }



  /*String appbarStackBoxText(WeekDay weekday) {
    String text = '';
    if (isToday(weekday)) {
      debugPrint('format ${weekday.jalaliDate.formatter.dd}');
      text = intl.todayAdvicesForYou;
    } else {
      text = intl.viewingMenu(
          '${weekday.jalaliDate.formatter.wN} ${weekday.jalaliDate.formatter.d} ${weekday.jalaliDate.formatter.mN}');
    }
    return text;
  }*/

  bool isToday(WeekDay weekDay) {
    return weekDay.gregorianDate.toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10);
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
