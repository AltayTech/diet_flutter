import 'package:behandam/base/errors.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:behandam/extensions/iterable.dart';

import 'provider.dart';
import 'week_day.dart';

class WeekList extends StatefulWidget {
  const WeekList({Key? key, required this.isClickable}) : super(key: key);

  final bool isClickable;

  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends ResourcefulState<WeekList> {
  late FoodListBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = FoodListProvider.of(context);

    return StreamBuilder(
      stream: bloc.weekDays,
      builder: (_, AsyncSnapshot<List<WeekDay?>?> snapshot) {
        if (snapshot.error is NoResultFoundError) {
          return SearchNoResult(intl.foodNotFoundMessage);
        }
        if (snapshot.data.isNullOrEmpty) {
          return EmptyBox();
        }
        debugPrint('snapshot ${snapshot.data?.length} / ');
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
    return StreamBuilder(
      stream: bloc.selectedWeekDay,
      builder: (_, AsyncSnapshot<WeekDay> snapshot){
        if(snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              if(widget.isClickable) bloc.changeDateWithString(
                  weekDays[index]!.gregorianDate.toString().substring(0, 10));
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
                            color: isEqualToSelectedDay(
                                weekDays, index, snapshot.requireData)
                                ? AppColors.surface
                                : null,
                          ),
                          padding: EdgeInsets.all(2.w),
                          child: Center(
                            child: Text(
                              weekDays[index]!.jalaliDate.day.toString(),
                              textAlign: TextAlign.center,
                              style: typography.caption?.apply(
                                color: isEqualToSelectedDay(
                                    weekDays, index, snapshot.requireData)
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
                              color: isEqualToSelectedDay(
                                  weekDays, index, snapshot.requireData)
                                  ? AppColors.surface
                                  : AppColors.primary,
                            ),
                            padding: EdgeInsets.all(1.w),
                            child: Icon(
                              Icons.check,
                              size: 5.w,
                              color: isEqualToSelectedDay(
                                  weekDays, index, snapshot.requireData)
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
        return Center(child: Progress());
      },
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

  bool isEqualToSelectedDay(List<WeekDay?> weekDays, int index, WeekDay weekday){
    return weekDays[index]!.gregorianDate ==
        weekDays.firstWhere((element) => element == weekday)!.gregorianDate;
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
