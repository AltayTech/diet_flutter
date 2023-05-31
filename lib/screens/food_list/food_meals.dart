import 'dart:io';

import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/const_&_model/food_meal_alarm.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/food_meals_notification_manager.dart';
import 'package:behandam/utils/image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';
import 'bloc.dart';
import 'provider.dart';
import 'week_day.dart';

class FoodMeals extends StatefulWidget {
  const FoodMeals({Key? key}) : super(key: key);

  @override
  _FoodMealsState createState() => _FoodMealsState();
}

class _FoodMealsState extends ResourcefulState<FoodMeals> {
  late FoodListBloc bloc;

  int androidSdk = 0;

  @override
  void initState() {
    super.initState();

    checkAndroidVersion();
  }

  @override
  Widget build(BuildContext context) {
    bloc = FoodListProvider.of(context);
    super.build(context);

    return foodMeals();
  }

  Future<int> checkAndroidVersion() async {
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var androidInfo = await deviceInfo.androidInfo;

      androidSdk = androidInfo.version.sdkInt;

      return androidSdk;
    } else {
      return 0;
    }
  }

  Widget foodMeals() {
    return StreamBuilder(
        stream: bloc.foodList,
        builder: (_, AsyncSnapshot<FoodListData?> snapshot) {
          if (snapshot.error is NoResultFoundError) {
            return SearchNoResult(intl.foodNotFoundMessage);
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return EmptyBox();
          }
          return Column(
            children: [
              ...snapshot.requireData!.meals!.mapIndexed((meal, index) {
                if (meal.startAt.isNotNullAndEmpty && meal.endAt.isNotNullAndEmpty) {
                  FoodMealAlarm foodMeal = FoodMealAlarm(
                      id: index,
                      title: meal.title,
                      type: meal.id,
                      time: int.parse(meal.startAt!.substring(0, 2)).toString() +
                          int.parse(meal.startAt!.substring(3, 5)).toString());

                  return mealItem(meal, index, foodMeal);
                }

                return mealItem(meal, index, null);
              }).toList(),
              Space(height: 5.h)
            ],
          );
        });
  }

  double getFoodItemHeight(int length) {
    double height = 200;

    if (length == 2) {
      height += 50;
      return height;
    }

    for (int i = 2; i < length; i++) {
      if (i % 2 == 0) {
        height += 135;
      }
    }

    return height;
  }

  Widget mealItem(Meals meal, int index, FoodMealAlarm? foodMeal) {
    final isCurrentMeal = checkCurrentMeal(meal);

    double height = meal.startAt.isNotNullAndEmpty && meal.endAt.isNotNullAndEmpty
        ? meal.food!.foodItems != null && meal.food!.foodItems!.length >= 2
            ? getFoodItemHeight(meal.food!.foodItems!.length)
            : 200
        : meal.description == null
            ? 175
            : 200;

    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        return StreamBuilder<bool>(
            stream: bloc.onChangeAlarmEnable,
            initialData: true,
            builder: (context, onChangeAlarmEnable) {
              if (foodMeal != null) {
                foodMeal = FoodMealsNotificationManager.checkIsExistAlarm(foodMeal!);
              }

              return Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          height: height,
                          margin: EdgeInsets.only(bottom: 2.w, top: 1.h),
                          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                          decoration: BoxDecoration(
                            color: isCurrentMeal && isToday(snapshot.data)
                                ? AppColors.primary.withOpacity(0.4)
                                : AppColors.onPrimary,
                            borderRadius: BorderRadius.only(
                              topRight: AppRadius.radiusSmall,
                              bottomRight:
                                  (meal.food != null && meal.food!.description.isNullOrEmpty)
                                      ? AppRadius.radiusSmall
                                      : Radius.zero,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Container(
                                    width: 12.w,
                                    height: 12.w,
                                    decoration: AppDecorations.circle.copyWith(
                                      color: isCurrentMeal && isToday(snapshot.data)
                                          ? AppColors.onPrimary
                                          : meal.bgColor,
                                    ),
                                    child: ImageUtils.fromLocal(
                                        'assets/images/foodlist/${meal.icon}.svg',
                                        color: isCurrentMeal && isToday(snapshot.data)
                                            ? meal.color
                                            : meal.color,
                                        padding: EdgeInsets.all(2.w)),
                                  ),
                                  Space(width: 2.w),
                                  Expanded(
                                    child: Text(
                                      meal.title,
                                      style: typography.bodySmall?.apply(
                                        fontSizeDelta: 1,
                                        fontWeightDelta: 1,
                                      ),
                                      softWrap: true,
                                    ),
                                  ),
                                  if (Platform.isAndroid &&
                                      androidSdk >= 26 &&
                                      meal.startAt.isNotNullAndEmpty &&
                                      meal.startAt.isNotNullAndEmpty)
                                    GestureDetector(
                                      onTap: () async {
                                        if (foodMeal != null) {
                                          if (FoodMealsNotificationManager.checkSetAlarm(
                                              foodMeal!)) {
                                            FoodMealsNotificationManager.disableAlarm(foodMeal!);
                                          } else {
                                            FoodMealsNotificationManager.enableAlarm(foodMeal!);

                                            FoodMealsNotificationManager.setAlarmMeals(
                                                index,
                                                meal.title,
                                                meal.food!.title!,
                                                DateTime(
                                                    int.parse(snapshot.data!.gregorianDate
                                                        .toString()
                                                        .substring(0, 4)),
                                                    int.parse(snapshot.data!.gregorianDate
                                                        .toString()
                                                        .substring(5, 7)),
                                                    int.parse(snapshot.data!.gregorianDate
                                                        .toString()
                                                        .substring(8, 10)),
                                                    int.parse(meal.startAt!.substring(0, 2)),
                                                    int.parse(meal.startAt!.substring(3, 5))));
                                          }

                                          bloc.updateAlarmEnableUi();
                                        }
                                      },
                                      child: foodMeal != null && foodMeal!.isEnabled!
                                          ? ImageUtils.fromLocal(
                                              'assets/images/diet/notification_icon.svg',
                                              width: 6.w,
                                              height: 6.w)
                                          : ImageUtils.fromLocal(
                                              'assets/images/diet/notification_icon_disable.svg',
                                              width: 6.w,
                                              height: 6.w),
                                    )
                                ],
                              ),
                              Space(height: 1.h),
                              if (meal.startAt.isNotNullAndEmpty && meal.endAt.isNotNullAndEmpty)
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          intl.mealStartAt,
                                          style: typography.labelSmall!.copyWith(fontSize: 9.sp),
                                          softWrap: true,
                                        ),
                                        Text(
                                          meal.startAt!.substring(0, 5),
                                          style: typography.bodyLarge,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                    Space(width: 10.w),
                                    Column(
                                      children: [
                                        Text(
                                          intl.mealEndAt,
                                          style: typography.labelSmall!.copyWith(fontSize: 9.sp),
                                          softWrap: true,
                                        ),
                                        Text(
                                          meal.endAt!.substring(0, 5),
                                          style: typography.bodyLarge,
                                          softWrap: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              Space(height: 1.h),
                              if (meal.food?.foodItems != null && meal.food!.foodItems!.isNotEmpty)
                                Expanded(
                                    child:
                                        foodItems(meal, isCurrentMeal && isToday(snapshot.data))),
                            ],
                          ),
                        ),
                        if (meal.food?.description != null)
                          recipeBox(meal, isCurrentMeal && isToday(snapshot.data)),
                      ],
                    ),
                  ),
                  alternateFood(meal, isCurrentMeal, height),
                ],
              );
            });
      },
    );
  }

  bool checkCurrentMeal(Meals meal) {
    return meal.startAt.isNotNullAndEmpty &&
        meal.endAt.isNotNullAndEmpty &&
        convertTimeOfDayToHour(TimeOfDay.now()) >=
            convertTimeOfDayToHour(TimeOfDay(
                hour: int.parse(meal.startAt!.substring(0, 2)),
                minute: int.parse(meal.startAt!.substring(3, 5)))) &&
        convertTimeOfDayToHour(TimeOfDay.now()) <=
            convertTimeOfDayToHour(TimeOfDay(
                hour: int.parse(meal.endAt!.substring(0, 2)),
                minute: int.parse(meal.endAt!.substring(3, 5))));
  }

  int convertTimeOfDayToHour(TimeOfDay timeOfDay) {
    return (timeOfDay.hour * 60) + timeOfDay.minute;
  }

  Widget alternateFood(Meals meal, bool isCurrentMeal, double itemHeight) {
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.hasData && isToday(snapshot.requireData)) {
          return GestureDetector(
            onTap: () => manipulateFoodDialog(meal),
            child: RotatedBox(
              quarterTurns: -45,
              child: Container(
                width: itemHeight,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                decoration: BoxDecoration(
                    color: isCurrentMeal && isToday(snapshot.data)
                        ? AppColors.primary.withOpacity(0.4)
                        : AppColors.onPrimary,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RotatedBox(
                        quarterTurns: 45,
                        child: ImageUtils.fromLocal('assets/images/diet/arrow_left_right.svg',
                            width: 4.w, height: 4.w)),
                    Space(width: 2.w),
                    Text(
                      intl.manipulateFood,
                      textAlign: TextAlign.center,
                      style: typography.labelSmall!.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return EmptyBox();
      },
    );
  }

  bool isToday(WeekDay? weekDay) {
    return weekDay != null &&
        DateTime.now().toString().substring(0, 10) ==
            weekDay.gregorianDate.toString().substring(0, 10);
  }

  void manipulateFoodDialog(Meals meal) {
    VxNavigator.of(context).waitAndPush(Uri(path: Routes.listFood), params: meal).then((value) {
      bloc.onMealFood(value, meal.id);
    });
  }

  Widget close() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: AppDecorations.boxSmall.copyWith(
            color: AppColors.primary.withOpacity(0.4),
          ),
          padding: EdgeInsets.all(1.w),
          child: Icon(
            Icons.close,
            size: 6.w,
            color: AppColors.onPrimary,
          ),
        ),
      ),
    );
  }

  Widget foodItems(Meals meal, bool isCurrentMeal) {
    List<int> items = meal.food?.foodItems == null
        ? []
        : List.generate((meal.food!.foodItems!.length * 2) - 1, (i) => i);
    if (meal.food?.freeFood != null) {
      items.add(items.last + 1);
      items.add(items.last + 1);
    }
    debugPrint('free food ${meal.food?.freeFood} / $items');
    int index = 0;
    return Container(
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        textDirection: TextDirection.rtl,
        children: [
          ...items.map(
            (i) {
              final widget;
              if (i % 2 == 0) {
                debugPrint('even item ${!meal.food!.freeFood.isNullOrEmpty} / $i');
                if (!meal.food!.freeFood.isNullOrEmpty && i == items.length - 1) {
                  widget = Chip(
                    backgroundColor: isCurrentMeal
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.backLabelColorFood,
                    label: FittedBox(
                      child: Text(
                        '${meal.food!.freeFood}',
                        style: typography.labelSmall!.copyWith(color: AppColors.labelColorFood),
                        textAlign: TextAlign.center,

                        // softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                } else {
                  widget = Chip(
                    backgroundColor: isCurrentMeal
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.backLabelColorFood.withOpacity(0.2),
                    label: FittedBox(
                      child: Text(
                        '${meal.food!.foodItems![index].amount} ${meal.food!.foodItems![index].title}',
                        style: typography.labelSmall!.copyWith(color: AppColors.labelColorFood),
                        textAlign: TextAlign.center,
                        // softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                }
              } else {
                widget = Icon(
                  Icons.add,
                  size: 6.w,
                );
                index++;
              }
              return widget;
            },
          ).toList(),
          Space(height: 2.h)
        ],
      ),
    );
  }

  Widget recipeBox(Meals meal, bool isCurrentMeal) {
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.hasData && isToday(snapshot.requireData)) {
          return Container(
            decoration: BoxDecoration(
              color: isCurrentMeal
                  ? AppColors.primary.withOpacity(0.2)
                  : AppColors.labelColor.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                bottomLeft: AppRadius.radiusSmall,
                bottomRight: AppRadius.radiusSmall,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
            child: GestureDetector(
              onTap: () => recipeDialog(meal),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ImageUtils.fromLocal(
                    'assets/images/diet/guide_icon.svg',
                    width: 6.w,
                    height: 6.w,
                    color: AppColors.primary,
                  ),
                  Space(width: 2.w),
                  Text(
                    intl.recipe(''),
                    textAlign: TextAlign.end,
                    style: typography.labelSmall,
                  ),
                ],
              ),
            ),
          );
        }
        return EmptyBox();
      },
    );
  }

  void recipeDialog(Meals meal) {
    DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              close(),
              Text(
                intl.recipe(meal.food!.title ?? ''),
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                meal.food!.description ?? '',
                style: typography.caption,
                textAlign: TextAlign.start,
                softWrap: true,
              ),
              Space(height: 2.h),
            ],
          ),
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

  // List<Widget> _items(List content, bool current, int index, double width) {
  //   print('contentctx $current / $content ');
  //   List<Widget> widgets = [];
  //   int counter = 0;
  //   if (content != null) {
  //     for (int i = 0; i < (content.length * 2) - 1; i++) {
  //       String unit = '';
  //       if (i % 2 == 0) {
  //         if (current != null) {
  //           print('content2 $content');
  //           if (content[counter]['amount'] != null) {
  //             if (content[counter]['amount']['default_unit'] != null &&
  //                 content[counter]['amount']['default_unit']
  //                 ['representational'] !=
  //                     null &&
  //                 content[counter]['amount']['default_unit']['representational']
  //                     .toString()
  //                     .length >
  //                     0 &&
  //                 content[counter]['amount']['default_unit']['representational']
  //                     .toString() !=
  //                     '0')
  //               unit =
  //               '${content[counter]['amount']['default_unit']['representational']} ${content[counter]['amount']['default_unit']['title'] ?? ''}';
  //             if (content[counter]['amount']['second_unit'] != null &&
  //                 content[counter]['amount']['second_unit']['representational'] !=
  //                     null &&
  //                 content[counter]['amount']['second_unit']['representational']
  //                     .toString()
  //                     .length >
  //                     0 &&
  //                 content[counter]['amount']['second_unit']['representational']
  //                     .toString() !=
  //                     '0')
  //               unit = unit.length > 0
  //                   ? '$unit و ${content[counter]['amount']['second_unit']['representational']} ${content[counter]['amount']['second_unit']['title'] ?? ''}'
  //                   : '${content[counter]['amount']['second_unit']['representational']} ${content[counter]['amount']['second_unit']['title'] ?? ''}';
  //           }
  //         }
  //         print('finderror ${unit ?? null} / $counter ');
  //
  //         widgets.add(Chip(
  //           backgroundColor: current == null
  //               ? Colors.white
  //               : current
  //               ? _colors[index]['currentAccent']
  //               : _colors[index]['itemBgColor'],
  //           label: FittedBox(
  //             child: Text(
  //               current != null
  //                   ? '${unit ?? ''} ${content[counter]['title'].toString() ?? ''}'
  //                   : content != null && content.length > 0
  //                   ? content[counter].toString()
  //                   : '',
  //               textDirection: TextDirection.rtl,
  //               textAlign: TextAlign.start,
  //               style: TextStyle(
  //                 color: current == null
  //                     ? Color.fromRGBO(119, 117, 118, 1)
  //                     : current
  //                     ? Color.fromRGBO(88, 88, 88, 1)
  //                     : Color.fromRGBO(147, 147, 147, 1),
  //                 fontSize: width * 5,
  //               ),
  //             ),
  //           ),
  //         ));
  //         counter++;
  //       } else {
  //         widgets.add(ImageUtils.fromLocal(
  //           'assets/images/foodlist/plus.svg',
  //           width: width * 4,
  //           height: width * 4,
  //           fit: BoxFit.cover,
  //           color: current != null && current
  //               ? _colors[index]['currentAccent']
  //               : _colors[index]['plusColor'],
  //         ));
  //       }
  //     }
  //   }
  //   return widgets;
  // }
  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
