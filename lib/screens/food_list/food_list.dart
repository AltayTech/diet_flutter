import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/change_menu.dart';
import 'package:behandam/screens/food_list/food_list_appbar.dart';
import 'package:behandam/screens/food_list/food_meals.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/food_list/week_day.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
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
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          FoodListAppbar(),
                          appbarStackBox(),
                        ],
                      ),
                      Space(height: 2.h),
                      ChangeMenu(),
                      Space(height: 2.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 3.w),
                        child: FoodMeals(),
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

  Widget appbarStackBox() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: StreamBuilder(
            stream: bloc.selectedWeekDay,
            builder: (_, AsyncSnapshot<WeekDay?> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        appbarStackBoxText(snapshot.requireData!),
                        style: typography.caption,
                        softWrap: true,
                      ),
                    ),
                    SubmitButton(
                      label: isToday(snapshot.requireData!) ? intl.showAdvices : intl.goToToday,
                      size: Size(40.w, 5.h),
                      onTap: isToday(snapshot.requireData!)
                          ? () => VxNavigator.of(context).push(Uri(path: Routes.advice))
                          : () =>
                              bloc.changeDateWithString(DateTime.now().toString().substring(0, 10)),
                    ),
                  ],
                );
              }
              return Center(child: Progress());
            },
          ),
        ),
      ),
    );
  }

  String appbarStackBoxText(WeekDay weekday) {
    String text = '';
    if (isToday(weekday)) {
      debugPrint('format ${weekday.jalaliDate.formatter.dd}');
      text = intl.todayAdvicesForYou;
    } else {
      text = intl.viewingMenu(
          '${DateTimeUtils.weekDayArabicName(weekday.jalaliDate.formatter.wN)} ${weekday.jalaliDate.formatter.d} ${weekday.jalaliDate.formatter.mN}');
    }
    return text;
  }

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
