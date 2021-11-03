import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/food_list_curve.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:behandam/extensions/iterable.dart';

import 'week_day.dart';

class FoodListAppbar extends StatefulWidget {
  const FoodListAppbar({Key? key}) : super(key: key);

  @override
  _FoodListAppbarState createState() => _FoodListAppbarState();
}

class _FoodListAppbarState extends ResourcefulState<FoodListAppbar> {
  late FoodListBloc bloc;
  int? _selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    bloc = FoodListProvider.of(context);
    super.build(context);

    return appbar();
  }

  Widget appbar() {
    return Container(
      height: 36.h,
      color: Colors.transparent,
      child: ClipPath(
        clipper: FoodListCurve(),
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Row(
                  children: [
                    Icon(
                      Icons.dark_mode,
                      size: 6.w,
                      color: AppColors.surface,
                    ),
                    Expanded(
                      child: StreamBuilder(
                        stream: bloc.foodList,
                        builder: (_, AsyncSnapshot<FoodListData?> snapshot) =>
                            Text(
                          '${intl.foodList} | ${snapshot.data?.menu?.title ?? ''}',
                          textAlign: TextAlign.center,
                          style: typography.caption?.apply(
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.dark_mode,
                      size: 6.w,
                      color: AppColors.surface,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: Divider(
                  thickness: 0.3,
                  color: AppColors.surface,
                  height: 3.h,
                ),
              ),
              calendar(),
              Space(height: 2.h),
              weekList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendar() {
    return Container(
      decoration: AppDecorations.boxLarge.copyWith(
        color: AppColors.surface.withOpacity(0.3),
      ),
      width: 40.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.dark_mode,
            size: 6.w,
            color: AppColors.surface,
          ),
          Space(width: 3.w),
          Text(
            'تقویم',
            textAlign: TextAlign.center,
            style: typography.caption?.apply(
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }

  Widget weekList() {
    return StreamBuilder(
      stream: bloc.weekDays,
      builder: (_, AsyncSnapshot<List<WeekDay?>?> snapshot) {
        if (snapshot.error is NoResultFoundError) {
          return SearchNoResult(intl.foodNotFoundMessage);
        }
        if (snapshot.data.isNullOrEmpty) {
          return EmptyBox();
        }
        if (_selectedDayIndex == null)
          _selectedDayIndex = snapshot.requireData!.indexWhere((element) =>
              element!.gregorianDate.toString().substring(0, 10) ==
              DateTime.now().toString().substring(0, 10));
        debugPrint('snapshot ${snapshot.data?.length} / $_selectedDayIndex');
        return Container(
          height: 13.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (_, index) {
              return Row(
                children: [
                  if (index == 0) Space(width: 3.w),
                  weekItem(index, snapshot.requireData!),
                  if (index == snapshot.requireData!.length - 1)
                    Space(width: 3.w),
                ],
              );
            },
            separatorBuilder: (_, index) => Space(width: 2.w),
            itemCount: snapshot.requireData!.length,
          ),
        );
      },
    );
  }

  Widget weekItem(int index, List<WeekDay?> weekDays) {
    return GestureDetector(
      onTap: () {
          bloc.changeDate(weekDays[index]!.gregorianDate.toString().substring(0, 10));
          setState(() {
            _selectedDayIndex = index;
          });
      },
      child: Container(
        width: 18.w,
        height: double.infinity,
        // color: AppColors.surface.withOpacity(0.3),
        child: Column(
          children: [
            Text(
              weekDays[index]!.jalaliDate.formatter.wN,
              textAlign: TextAlign.center,
              style: typography.caption?.apply(
                color: AppColors.surface,
              ),
            ),
            Space(height: 1.h),
            Stack(
              children: [
                Container(
                  height: 6.5.h,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  left: 0,
                  child: Container(
                    decoration: AppDecorations.circle.copyWith(
                      border: isAfterToday(weekDays[index]!)
                          ? null
                          : Border.all(
                              color: AppColors.surface,
                              width: 0.4,
                            ),
                      color: isEqualToSelectedDay(weekDays, index)
                          ? AppColors.surface
                          : null,
                    ),
                    padding: EdgeInsets.all(2.w),
                    child: Center(
                      child: Text(
                        weekDays[index]!.jalaliDate.day.toString(),
                        textAlign: TextAlign.center,
                        style: typography.caption?.apply(
                          color: isEqualToSelectedDay(weekDays, index)
                              ? AppColors.primary
                              : AppColors.surface,
                        ),
                      ),
                    ),
                  ),
                ),
                if (isBeforeToday(weekDays[index]!))
                  Positioned(
                    bottom: 0,
                    right: 0,
                    left: 0,
                    child: Container(
                      decoration: AppDecorations.circle.copyWith(
                        color: isEqualToSelectedDay(weekDays, index)
                            ? AppColors.surface
                            : AppColors.primary,
                      ),
                      padding: EdgeInsets.all(1.w),
                      child: Icon(
                        Icons.check,
                        size: 5.w,
                        color: isEqualToSelectedDay(weekDays, index)
                            ? AppColors.primary
                            : AppColors.surface,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isAfterToday(WeekDay day){
    return day.gregorianDate.isAfter(DateTime.parse(
        DateTime.now().toString().substring(0, 10)));
  }

  bool isBeforeToday(WeekDay day){
    return day.gregorianDate.isBefore(
        DateTime.parse(DateTime.now().toString().substring(0, 10)));
  }

  bool isEqualToSelectedDay(List<WeekDay?> weekDays, int index){
    return weekDays[index]!.gregorianDate ==
        weekDays[_selectedDayIndex!]!.gregorianDate;
  }
}
