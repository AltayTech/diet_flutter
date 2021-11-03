import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/list.dart';
import 'package:behandam/extensions/string.dart';

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
  late int _selectedDayIndex;

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
              ...snapshot.requireData!.meals
                  .map((meal) => mealItem(snapshot.requireData!, meal))
                  .toList(),
            ],
          );
        });
  }

  Widget mealItem(FoodListData foodListData, Meals meal) {
    return Card(
      margin: EdgeInsets.only(bottom: 2.h),
      shape: AppShapes.rectangleMild,
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                StreamBuilder(
                  stream: bloc.date,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return Row(
                      children: <Widget>[
                        Container(
                          width: 15.w,
                          height: 15.w,
                          decoration: AppDecorations.circle.copyWith(
                            color: AppColors.primary,
                          ),
                          // child: ImageUtils(),
                        ),
                        Space(width: 2.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal.title,
                                style: typography.bodyText2,
                                softWrap: true,
                              ),
                              if (meal.description.isNotNullAndEmpty)
                                Text(
                                  meal.description!,
                                  style: typography.caption,
                                  softWrap: true,
                                ),
                            ],
                          ),
                        ),
                        Space(width: 2.w),
                        // if(DateTime.now().toString().substring(0, 10) == )
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: AppDecorations.boxLarge.copyWith(
                              border: Border.all(
                                color: AppColors.onSurface,
                                width: 0.4,
                              ),
                            ),
                            child: Text(
                              intl.manipulateFood,
                              textAlign: TextAlign.center,
                              style: typography.caption,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Container(
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    direction: Axis.horizontal,
                    textDirection: TextDirection.rtl,
                    children: [
                      // ...meal.food.ratios[0].ratioFoodItems.map((foodItem) => null).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(2.5.w),
                bottomRight: Radius.circular(2.5.w),
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
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
                  intl.recipe,
                  textAlign: TextAlign.end,
                  style: typography.caption,
                ),
              ],
            ),
          ),
          // Space(height: 1.h),
        ],
      ),
    );
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
  //         widgets.add(SvgPicture.asset(
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
}
