import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class ChangeMealFoodPage extends StatefulWidget {
  const ChangeMealFoodPage({Key? key}) : super(key: key);

  @override
  _ChangeMealFoodPageState createState() => _ChangeMealFoodPageState();
}

class _ChangeMealFoodPageState extends ResourcefulState<ChangeMealFoodPage>
    with SingleTickerProviderStateMixin {
  Meals? meal;
  late FoodListBloc bloc;
  late AnimationController _animationController;
  late Animation<double> _animation;
  Tween<double> _tween = Tween(begin: 0.9, end: 1.3);
  late Map<String, dynamic> args;

  @override
  void initState() {
    super.initState();
    // bloc = FoodListBloc(false);
    _animationController =
        AnimationController(duration: const Duration(milliseconds: 2000), vsync: this, value: 1);
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = _tween.animate(_animation);
    _animationController.repeat();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
    meal = args['meal'];
    bloc = args['bloc'];
    // bloc.makingFoodEmpty(meal!.id);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.manipulateFood),
      body: body(),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: bloc.loadingContent,
        builder: (_, AsyncSnapshot<bool> snapshot) {
          return Column(
            children: [
              Stack(
                children: [
                  currentMeal(),
                  Positioned(
                    bottom: -5,
                    right: 0,
                    left: 0,
                    child: Icon(
                      Icons.arrow_downward_rounded,
                      color: AppColors.primary,
                      size: 10.w,
                    ),
                  )
                ],
              ),
              Space(height: 2.h),
              StreamBuilder(
                stream: bloc.foodList,
                builder: (_, AsyncSnapshot<FoodListData?> snapshot) {
                  if (snapshot.hasData) {
                    return replaceBox(snapshot.requireData!.meals
                        ?.firstWhere((element) => element.id == meal!.id));
                  }
                  return Progress();
                },
              ),
              Space(
                height: 6.h,
              ),
              SubmitButton(
                label: intl.replaceFood,
                onTap: () {
                  if (meal?.newFood != null) {
                    bloc.onReplacingFood(meal!.id);
                    VxNavigator.of(context).pop();
                  } else
                    Utils.getSnackbarMessage(context, intl.selectReplacedFood);
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget currentMeal() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Container(
        decoration: AppDecorations.boxMild.copyWith(
          color: AppColors.onPrimary,
        ),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: AppDecorations.boxMild.copyWith(
                color: AppColors.primary.withOpacity(0.4),
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: AppDecorations.circle.copyWith(
                          color: AppColors.onPrimary,
                        ),
                        child: ImageUtils.fromLocal('assets/images/foodlist/${meal?.icon}.svg',
                            placeholder: "assets/images/foodlist/meal-1.svg",
                            color: meal?.color,
                            padding: EdgeInsets.all(2.w)),
                      ),
                      Space(width: 2.w),
                      Expanded(
                        child: Text(
                          intl.currentMeal(meal?.title ?? ''),
                          style: typography.bodyText2,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  Space(height: 1.h),
                  Text(
                    meal?.food?.title ?? '',
                    style: typography.caption,
                    softWrap: true,
                  ),
                  Space(height: 1.h),
                  foodItems(),
                ],
              ),
            ),
            Space(height: 3.h),
            Text(
              intl.replaceMeal(meal?.title ?? ''),
              style: typography.bodyText2?.apply(
                color: AppColors.primary,
              ),
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            Space(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget foodItems() {
    int freeFoodLength = meal?.food?.freeFood != null && meal!.food!.freeFood!.isNotEmpty ? 1 : 0;
    List<int> items = meal?.food == null
        ? []
        : List.generate(((meal!.food!.foodItems!.length + freeFoodLength) * 2) - 1, (i) => i);
    // (meal!.food!.ratios![0].ratioFoodItems!.length * 2) - 1, (i) => i);
    int index = 0;
    return Container(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.center,
        direction: Axis.horizontal,
        textDirection: TextDirection.rtl,
        children: [
          ...items.map(
            (i) {
              debugPrint('index $index / $i / ${i == items.length - 1 && items.length > 1}');
              final widget;
              if (i % 2 == 0) {
                widget = Chip(
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  label: Text(
                    // '${meal!.food!.ratios![0].ratioFoodItems![index].unitTitle.replaceAll('*', intl.and)} ${meal!.food!.ratios![0].ratioFoodItems![index].title}',
                    i == items.length - 1 && freeFoodLength == 1
                        ? meal?.food?.freeFood ?? ''
                        : meal?.food?.foodItems?[index].title ?? '',
                    style: typography.caption,
                    textAlign: TextAlign.center,
                    // softWrap: true,
                    overflow: TextOverflow.visible,
                  ),
                );
                index++;
              } else {
                widget = Icon(
                  Icons.add,
                  size: 6.w,
                );
              }
              return widget;
            },
          ).toList(),
        ],
      ),
    );
  }

  Widget replaceBox(Meals? meal) {
    List<String> items = meal?.newFood == null ? [] : meal!.newFood!.title!.split("+");

    if (meal?.newFood?.selectedFreeFood != null)
      items.add(meal?.newFood?.selectedFreeFood?.title ?? '');

    debugPrint('items => ${items.length}');

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 3.w),
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
                    color: meal?.bgColor,
                  ),
                  child: ImageUtils.fromLocal('assets/images/foodlist/${meal?.icon}.svg',
                      placeholder: "assets/images/foodlist/meal-1.svg",
                      color: meal?.color,
                      padding: EdgeInsets.all(2.w)),
                ),
                Space(width: 2.w),
                Expanded(
                  child: Text(
                    meal?.title ?? '',
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
                    .then((value) => bloc.onMealFood(value, meal!.id));
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
                          meal?.newFood == null ? Icons.add : Icons.edit,
                          size: 6.w,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Space(width: 2.w),
                    Expanded(
                      child: meal?.newFood == null
                          ? Text(
                              intl.addFood,
                              style: typography.caption,
                            )
                          : Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              children: [
                                ...items
                                    .asMap()
                                    .map(
                                      (i, item) {
                                        return MapEntry(
                                            i,
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Chip(
                                                  backgroundColor: AppColors.onPrimary,
                                                  label: Text(
                                                    item,
                                                    style: typography.caption,
                                                    textAlign: TextAlign.center,
                                                    softWrap: true,
                                                  ),
                                                ),
                                                if (i != items.length - 1)
                                                  Icon(
                                                    Icons.add,
                                                    size: 6.w,
                                                  )
                                              ],
                                            ));
                                      },
                                    )
                                    .values
                                    .toList(),
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
