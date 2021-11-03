import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/food_list_appbar.dart';
import 'package:behandam/screens/food_list/food_meals.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/food_list/week_day.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:behandam/base/resourceful_state.dart';

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
    bloc = FoodListBloc();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          item(intl.selectDailyMenu),
                          item(intl.iFastToday),
                        ],
                      ),
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
                    Container(
                      width: 60,
                      height: 20,
                    ),
                  ],
                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }

  String appbarStackBoxText(WeekDay weekday) {
    String text = '';
    if (weekday.gregorianDate.toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10)) {
      debugPrint('format ${weekday.jalaliDate.formatter.dd}');
      text = intl.todayAdvicesForYou;
    } else {
      text = intl.viewingMenu('${weekday.jalaliDate.formatter.wN} ${weekday.jalaliDate.formatter.d} ${weekday.jalaliDate.formatter.mN}');
    }
    return text;
  }

  Widget item(String text) {
    return Card(
      shape: AppShapes.rectangleMedium,
      elevation: 1,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.menu,
              size: 6.w,
            ),
            Space(width: 2.w),
            Text(
              text,
              style: typography.caption,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
