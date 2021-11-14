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
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:behandam/extensions/string.dart';
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
    bloc = FoodListBloc(false);
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
        floatingActionButton: floatingActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      snapshot.hasData
                          ? intl.selectFood(
                              '${snapshot.requireData.jalaliDate.formatter.wN} ${snapshot.requireData.jalaliDate.formatter.d} ${snapshot.requireData.jalaliDate.formatter.mN}')
                          : '',
                      style: typography.subtitle2,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      snapshot.hasData ? intl.notShowingPastMeals : '',
                      style: typography.caption,
                      softWrap: true,
                      textAlign: TextAlign.center,
                    ),
                  ],
                );
              },
            ),
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
                  Space(height: 10.h),
                ],
              );
            return EmptyBox();
          }),
    );
  }

  Widget mealItem(Meals meal) {
    List<int> items = meal.food == null
        ? []
        : List.generate(
            (meal.food!.ratios![0].ratioFoodItems!.length * 2) - 1, (i) => i);
    int index = 0;
    debugPrint('is past ${isPastMeal(meal)} / ${meal.title}');
    return isPastMeal(meal) ? Container() : Card(
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
              onTap: () {
                VxNavigator.of(context)
                    .waitAndPush(Uri(path: Routes.listFood), params: meal)
                    .then((value) => bloc.onMealFood(value, meal.id));
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
                          meal.food == null ? Icons.add : Icons.edit,
                          size: 6.w,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Space(width: 2.w),
                    Expanded(
                      child: meal.food == null
                          ? Text(
                              intl.addFood,
                              style: typography.caption,
                            )
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ...items.map(
                                  (i) {
                                    final widget;
                                    if (i % 2 == 0)
                                      widget = Chip(
                                        backgroundColor: AppColors.onPrimary,
                                        label: Text(
                                          meal
                                                  .food
                                                  ?.ratios?[0]
                                                  .ratioFoodItems?[index]
                                                  .title ??
                                              '',
                                          style: typography.caption,
                                          textAlign: TextAlign.center,
                                          softWrap: true,
                                        ),
                                      );
                                    else {
                                      widget = Icon(
                                        Icons.add,
                                        size: 6.w,
                                      );
                                      index++;
                                    }
                                    return widget;
                                  },
                                ).toList(),
                              ],
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

  bool isPastMeal(Meals meal) {
    return meal.startAt.isNotNullAndEmpty &&
            meal.endAt.isNotNullAndEmpty &&
            convertTimeOfDayToHour(TimeOfDay.now()) >=
                convertTimeOfDayToHour(TimeOfDay(
                    hour: int.parse(meal.endAt!.substring(0, 2)),
                    minute: int.parse(meal.endAt!.substring(3, 5))));
  }

  int convertTimeOfDayToHour(TimeOfDay timeOfDay) {
    return (timeOfDay.hour * 60) + timeOfDay.minute;
  }

  Widget floatingActionButton() {
    return StreamBuilder(
      stream: bloc.foodList,
      builder: (_, AsyncSnapshot<FoodListData?> snapshot) {
        return FloatingActionButton.extended(
          onPressed: () {
            bool isValid = true;
            snapshot.requireData?.meals.forEach((meal) {
              if (meal.food == null ||
                  meal.food!.foodItems == null ||
                  meal.food!.foodItems!.length == 0) {
                isValid = false;
                return;
              }
            });
            if (isValid)
              bloc.onDailyMenu(context);
            else {
              navigatorMessengerKey.currentState?.removeCurrentSnackBar();
              navigatorMessengerKey.currentState!.showSnackBar(SnackBar(
                content: Text(intl.selectFoodForAllMeals),
              ));
            }
            // VxNavigator.of(context).returnAndPush(true);
          },
          label: Text(
            intl.saveDailyMenu,
            style: typography.caption?.apply(
              color: AppColors.onPrimary,
            ),
            softWrap: false,
          ),
        );
      },
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