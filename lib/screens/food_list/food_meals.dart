import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
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

  @override
  Widget build(BuildContext context) {
    bloc = FoodListProvider.of(context);
    super.build(context);

    return foodMeals();
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
              ...snapshot.requireData!.meals!.map((meal) => mealItem(meal)).toList(),
            ],
          );
        });
  }

  Widget mealItem(Meals meal) {
    final isCurrentMeal = checkCurrentMeal(meal);
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          shape: AppShapes.rectangleMild,
          elevation: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isCurrentMeal && isToday(snapshot.data)
                      ? AppColors.primary.withOpacity(0.4)
                      : AppColors.onPrimary,
                  borderRadius: BorderRadius.only(
                    topLeft: AppRadius.radiusSmall,
                    topRight: AppRadius.radiusSmall,
                    bottomRight:
                        (meal.food!=null && meal.food!.description.isNullOrEmpty) ? AppRadius.radiusSmall : Radius.zero,
                    bottomLeft:
                    (meal.food!=null && meal.food!.description.isNullOrEmpty) ? AppRadius.radiusSmall : Radius.zero,
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
                                : AppColors.primary,
                          ),
                          child: ImageUtils.fromLocal(
                            'assets/images/foodlist/${meal.icon}.svg',
                            color: isCurrentMeal && isToday(snapshot.data)
                                ? AppColors.primary
                                : AppColors.onPrimary,
                            padding: EdgeInsets.all(2.w)
                          ),
                        ),
                        Space(width: 2.w),
                        Expanded(
                          child: Text(
                            meal.title,
                            style: typography.bodyText2,
                            softWrap: true,
                          ),
                        ),
                        Space(width: 2.w),
                        alternateFood(meal),
                      ],
                    ),
                    Space(height: 0.5.h),
                    if (meal.startAt.isNotNullAndEmpty && meal.startAt.isNotNullAndEmpty)
                      Text(
                        intl.timeOfTheMeal(
                            meal.startAt!.substring(0, 5), meal.endAt!.substring(0, 5)),
                        style: typography.caption,
                        softWrap: true,
                      ),
                    Space(height: 1.h),
                    if (meal.food?.foodItems != null && meal.food!.foodItems!.isNotEmpty)
                      foodItems(meal, isCurrentMeal && isToday(snapshot.data)),
                  ],
                ),
              ),
              if (meal.food?.description != null)
                recipeBox(meal, isCurrentMeal && isToday(snapshot.data)),
            ],
          ),
        );
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

  Widget alternateFood(Meals meal) {
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.hasData && isToday(snapshot.requireData))
          return GestureDetector(
            onTap: () => manipulateFoodDialog(meal),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: AppDecorations.boxLarge.copyWith(
                border: Border.all(
                  color: AppColors.onSurface,
                  width: 0.4,
                ),
                color: AppColors.onPrimary,
              ),
              child: Text(
                intl.manipulateFood,
                textAlign: TextAlign.center,
                style: typography.caption,
              ),
            ),
          );
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
    DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(vertical: 1.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: close(),
              ),
              Text(
                intl.alternating(meal.title),
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Stack(
                children: [
                  Container(height: 13.h),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    top: 2.5.h,
                    child: Container(
                      color: AppColors.primary.withOpacity(0.3),
                      padding: EdgeInsets.fromLTRB(3.w, 1.h, 3.w, 0),
                      child: Center(
                        child: Text(
                          intl.tryToAlternateOneMealDaily,
                          style: typography.subtitle2,
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Center(
                      child: Icon(
                        Icons.info,
                        color: AppColors.primary,
                        size: 9.w,
                      ),
                    ),
                  ),
                ],
              ),
              Space(height: 1.h),
              Container(
                alignment: Alignment.center,
                child: SubmitButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    VxNavigator.of(context)
                        .push(Uri(path: Routes.replaceFood), params: {'meal': meal, 'bloc': bloc});
                  },
                  label: intl.manipulateFood,
                ),
              ),
              Space(height: 1.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  intl.alternatingFoodLater,
                  style: typography.caption,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                if (!meal.food!.freeFood.isNullOrEmpty && i == items.length - 1)
                  widget = Chip(
                    backgroundColor: isCurrentMeal
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.labelColor.withOpacity(0.2),
                    label: FittedBox(
                      child: Text(
                        '${meal.food!.freeFood}',
                        style: typography.caption,
                        textAlign: TextAlign.center,
                        // softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
                else
                  widget = Chip(
                    backgroundColor: isCurrentMeal
                        ? AppColors.primary.withOpacity(0.2)
                        : AppColors.labelColor.withOpacity(0.2),
                    label: FittedBox(
                      child: Text(
                        '${meal.food!.foodItems![index].amount} ${meal.food!.foodItems![index].title}',
                        style: typography.caption,
                        textAlign: TextAlign.center,
                        // softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  );
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
        ],
      ),
    );
  }

  Widget recipeBox(Meals meal, bool isCurrentMeal) {
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.hasData && isToday(snapshot.requireData))
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
                    style: typography.caption,
                  ),
                ],
              ),
            ),
          );
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
