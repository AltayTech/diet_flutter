import 'package:behandam/base/errors.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/extensions/iterable.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/food_list_curve.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/search_no_result.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';
import 'week_day.dart';
import 'week_list.dart';

class FoodListAppbar extends StatefulWidget {
  FoodListAppbar({Key? key, this.showToolbar, this.isClickable}) : super(key: key);
  final bool? showToolbar;
  final bool? isClickable;

  @override
  _FoodListAppbarState createState() => _FoodListAppbarState();
}

class _FoodListAppbarState extends ResourcefulState<FoodListAppbar> {
  late FoodListBloc bloc;

  // int? _selectedDayIndex;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bloc = FoodListProvider.of(context);
    super.build(context);
    return appbar();
  }

  Widget appbar() {
    return Container(
      height: widget.showToolbar == null ? 40.h : 32.h,
      color: Colors.transparent,
      child: ClipPath(
        clipper: FoodListCurve(),
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          child: Column(
            children: [
              if (widget.showToolbar == null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Row(
                    children: [
                      Icon(
                        Icons.dark_mode,
                        size: 6.w,
                        color: Colors.transparent,
                      ),
                      Expanded(
                        child: StreamBuilder(
                          stream: bloc.foodList,
                          builder: (_, AsyncSnapshot<FoodListData?> snapshot) => Text(
                            '${intl.foodList} | ${snapshot.data?.menu?.title ?? ''}',
                            textAlign: TextAlign.center,
                            style: typography.caption?.apply(
                              color: AppColors.surface,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => DialogUtils.showDialogPage(
                            context: context,
                            child: Center(
                              child: Container(
                                margin: EdgeInsets.symmetric(horizontal: 5.w),
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                                width: double.maxFinite,
                                decoration: AppDecorations.boxLarge.copyWith(
                                  color: AppColors.onPrimary,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      intl.receiveList,
                                      style: TextStyle(fontWeight: FontWeight.w700),
                                      textAlign: TextAlign.center,
                                      textDirection: context.textDirectionOfLocale,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      intl.pdfTxt,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(color: AppColors.penColor),
                                      textDirection: context.textDirectionOfLocale,
                                    ),
                                    SizedBox(height: 3.h),
                                    SubmitButton(
                                        label: intl.receivePdf,
                                        onTap: () {
                                          Navigator.pop(context);
                                          DialogUtils.showDialogProgress(context: context);
                                          bloc.getPdfMeal(FoodDietPdf.WEEK);
                                        }),
                                    SizedBox(height: 1.h),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      style: ButtonStyle(
                                        fixedSize: MaterialStateProperty.all(Size(70.w, 5.h)),
                                        backgroundColor: MaterialStateProperty.all(Colors.white),
                                      ),
                                      child: Text(intl.cancelPdf,
                                          style: Theme.of(context)
                                              .textTheme
                                              .button!
                                              .copyWith(color: AppColors.btnColor)),
                                    ),
                                    SizedBox(height: 1.h),
                                  ],
                                ),
                              ),
                            )),
                        child: ImageUtils.fromLocal('assets/images/foodlist/share/pdf.svg',
                            width: 2.w, height: 4.h),
                      )
                    ],
                  ),
                ),
              if (widget.showToolbar == null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Divider(
                    thickness: 0.3,
                    color: AppColors.surface,
                    height: 3.h,
                  ),
                ),
              Row(
                children: [
                  Space(
                    width: 2.w,
                  ),
                  calendar(),
                  Expanded(
                    child: Space(),
                    flex: 1,
                  ),
                  adviceButton(),
                  Space(
                    width: 2.w,
                  ),
                ],
              ),
              Space(height: 2.h),
              WeekList(isClickable: widget.isClickable ?? true),
            ],
          ),
        ),
      ),
    );
  }

  Widget calendar() {
    return GestureDetector(
      onTap: () => VxNavigator.of(context).push(Uri(path: Routes.calendar)),
      child: Container(
        decoration: AppDecorations.boxLarge.copyWith(
          color: AppColors.surface.withOpacity(0.3),
        ),
        width: 35.w,
        padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 6.w,
              color: AppColors.surface,
            ),
            Space(width: 1.w),
            Text(
              intl.calendar,
              textAlign: TextAlign.center,
              style: typography.caption?.apply(
                color: AppColors.surface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget adviceButton(){
    return GestureDetector(
      child: Container(
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.surface.withOpacity(0.3),
          ),
          width: 30.w,
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageUtils.fromLocal(
                "assets/images/foodlist/advice/bulb.svg",
                width: 6.w,
                height: 6.w,
                color: AppColors.surface,
              ),
              Space(width: 1.w),
              Text(
                intl.showAdvices,
                textAlign: TextAlign.center,
                style: typography.caption?.apply(
                  color: AppColors.surface,
                ),
              ),
            ],
          )),
      onTap: () {
        VxNavigator.of(context).push(Uri(path: Routes.advice));
      },
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
                  if (index == snapshot.requireData!.length - 1) Space(width: 3.w),
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
      builder: (_, AsyncSnapshot<WeekDay> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
            onTap: () {
              bloc.changeDateWithString(weekDays[index]!.gregorianDate.toString().substring(0, 10));
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
                            color: isEqualToSelectedDay(weekDays, index, snapshot.requireData)
                                ? AppColors.surface
                                : null,
                          ),
                          padding: EdgeInsets.all(2.w),
                          child: Center(
                            child: Text(
                              weekDays[index]!.jalaliDate.day.toString(),
                              textAlign: TextAlign.center,
                              style: typography.caption?.apply(
                                color: isEqualToSelectedDay(weekDays, index, snapshot.requireData)
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
                              color: isEqualToSelectedDay(weekDays, index, snapshot.requireData)
                                  ? AppColors.surface
                                  : AppColors.primary,
                            ),
                            padding: EdgeInsets.all(1.w),
                            child: Icon(
                              Icons.check,
                              size: 5.w,
                              color: isEqualToSelectedDay(weekDays, index, snapshot.requireData)
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

  bool isAfterToday(WeekDay day) {
    return day.gregorianDate.isAfter(DateTime.parse(DateTime.now().toString().substring(0, 10)));
  }

  bool isBeforeToday(WeekDay day) {
    return day.gregorianDate.isBefore(DateTime.parse(DateTime.now().toString().substring(0, 10)));
  }

  bool isEqualToSelectedDay(List<WeekDay?> weekDays, int index, WeekDay weekday) {
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
