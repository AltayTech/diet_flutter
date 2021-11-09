import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/food_list/week_day.dart';
import 'package:behandam/screens/food_list/week_list.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/food_list_curve.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class DailyMenuPage extends StatefulWidget {
  const DailyMenuPage({Key? key}) : super(key: key);

  @override
  _DailyMenuPageState createState() => _DailyMenuPageState();
}

class _DailyMenuPageState extends ResourcefulState<DailyMenuPage>
    with SingleTickerProviderStateMixin {
  late FoodListBloc bloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Tween<double> _tween = Tween(begin: 0.9, end: 1.3);
  WeekDay? selectedWeekDay;

  @override
  void initState() {
    super.initState();
    bloc = FoodListBloc();
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 1);
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = _tween.animate(_animation);
    _animationController.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return FoodListProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.selectDailyMenuFoods),
        body: SafeArea(
          child: StreamBuilder(
            stream: bloc.loadingContent,
            builder: (_, AsyncSnapshot<bool> snapshot) {
              if (snapshot.error is NoResultFoundError) {
                return SearchNoResult(intl.foodNotFoundMessage);
              }
              if (!snapshot.hasData || snapshot.hasError) {
                return EmptyBox();
              }
              return content();
            },
          ),
        ),
      ),
    );
  }

  Widget content() {
    return SingleChildScrollView(
      child: Column(
        children: [
          weekList(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w),
            child: StreamBuilder(
              stream: bloc.selectedWeekDay,
              builder: (_, AsyncSnapshot<WeekDay> snapshot) {
                return Text(
                  snapshot.hasData
                      ? intl.selectFood(
                          '${snapshot.requireData.jalaliDate.formatter.wN} ${snapshot.requireData.jalaliDate.formatter.d} ${snapshot.requireData.jalaliDate.formatter.mN}')
                      : '',
                  style: typography.subtitle2,
                  softWrap: true,
                );
              },
            ),
          ),
          Text(
            intl.notShowingPastMeals,
            style: typography.caption,
            softWrap: true,
          ),
          Space(height: 2.h),
          selectingMeals(),
        ],
      ),
    );
  }

  Widget weekList() {
    return Container(
      height: 18.h,
      color: Colors.transparent,
      child: ClipPath(
        clipper: FoodListCurve(),
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: WeekList(isClickable: false),
        ),
      ),
    );
  }

  Widget selectingMeals() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: StreamBuilder(
          stream: bloc.foodList,
          builder: (_, AsyncSnapshot<FoodListData?> snapshot) {
            if (snapshot.hasData)
              return Column(
                children: [
                  ...snapshot.requireData!.meals
                      .map((meal) => mealItem(meal))
                      .toList(),
                ],
              );
            return EmptyBox();
          }),
    );
  }

  Widget mealItem(Meals meal) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: AppDecorations.circle.copyWith(
                    color: AppColors.primary,
                  ),
                  // child: ImageUtils(),
                ),
                Space(width: 2.w),
                Expanded(
                  child: Text(
                    meal.title,
                    style: typography.bodyText2,
                    softWrap: true,
                  ),
                ),
              ],
            ),
            Space(height: 1.h),
            GestureDetector(
              onTap: (){
                VxNavigator.of(context).push(Uri(path: Routes.listFood), params: meal.title);
              },
              child: Container(
                decoration: AppDecorations.boxMedium.copyWith(
                  color: Colors.grey[100],
                ),
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                child: Row(
                  children: [
                    Container(
                      decoration: AppDecorations.boxMild.copyWith(
                        color: AppColors.onPrimary,
                      ),
                      padding: EdgeInsets.all(3.w),
                      child: ScaleTransition(
                        scale: _animation,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.edit,
                          size: 6.w,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Space(width: 2.w),
                    Expanded(
                      child: Text(
                        intl.addFood,
                        style: typography.caption,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
}
