import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/widget/centered_circular_progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
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
                  if(snapshot.hasData) {
                    return replaceBox(snapshot.requireData!.meals?.firstWhere((
                        element) => element.id == meal!.id));
                  }
                  return CircularProgressIndicator();
                },
              ),
              Space(height: 6.h,),
              SubmitButton(label: intl.replaceFood, onTap: (){
                bloc.onReplacingFood(meal!.id);
                VxNavigator.of(context).pop();
              }),
            ],
          );
        },
      ),
    );
  }

  Widget currentMeal(){
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
          children: [
            Container(
              decoration: AppDecorations.boxMild.copyWith(
                color: AppColors.primary.withOpacity(0.4),
              ),
              padding:
              EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
                        // child: ImageUtils(),
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
            ),
            Space(height: 3.h),
          ],
        ),
      ),
    );
  }

  Widget foodItems() {
    List<int> items = meal?.food == null
        ? []
        : List.generate(
            (meal!.food.foodItems!.length * 2) - 1, (i) => i);
            // (meal!.food!.ratios![0].ratioFoodItems!.length * 2) - 1, (i) => i);
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
              if (i % 2 == 0)
                widget = Chip(
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  label: FittedBox(
                    child: Text(
                      // '${meal!.food!.ratios![0].ratioFoodItems![index].unitTitle.replaceAll('*', intl.and)} ${meal!.food!.ratios![0].ratioFoodItems![index].title}',
                      meal?.food?.foodItems?[index].title ??
                          '',
                      style: typography.caption,
                      textAlign: TextAlign.center,
                      // softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
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
    );
  }

  Widget replaceBox(Meals? meal) {
    List<int> items = meal?.newFood == null
        ? []
        : List.generate((meal!.newFood!.foodItems!.length * 2) - 1, (i) => i);
    int index = 0;
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
                    color: AppColors.primary,
                  ),
                  // child: ImageUtils(),
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
                                ...items.map(
                                  (i) {
                                    final widget;
                                    if (i % 2 == 0)
                                      widget = Chip(
                                        backgroundColor: AppColors.onPrimary,
                                        label: Text(
                                          meal?.newFood?.foodItems?[index].title ??
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
