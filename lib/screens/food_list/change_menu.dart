import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/fast/bloc.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/dialog.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';
import 'provider.dart';
import 'week_day.dart';

enum ChangeMenuType {
  DailyMenu,
  Fasting,
  ChangePatten,
  Original,
}

class ChangeMenu extends StatefulWidget {
  const ChangeMenu({Key? key}) : super(key: key);

  @override
  State<ChangeMenu> createState() => _ChangeMenuState();
}

class _ChangeMenuState extends ResourcefulState<ChangeMenu> {
  late FoodListBloc bloc;
  late AppBloc appBloc;
  FastBloc? fastBloc;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    bloc = FoodListProvider.of(context);
    appBloc = AppProvider.of(context);

    return StreamBuilder(
      stream: bloc.loadingContent,
      builder: (_, AsyncSnapshot<bool> loadingSnapshot) {
        if (loadingSnapshot.data == false)
          return StreamBuilder(
            stream: bloc.selectedWeekDay,
            builder: (_, AsyncSnapshot<WeekDay> snapshot) {
              if (snapshot.hasData && isTodayOrAfter(snapshot.requireData))
                return StreamBuilder(
                  stream: bloc.foodList,
                  builder: (_, AsyncSnapshot<FoodListData?> snapshotFoodList) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            flex: 1, child: item(ChangeMenuType.DailyMenu, loadingSnapshot.requireData, snapshot.requireData)),
                        Expanded(
                            flex: 1,
                            child: item(
                                snapshotFoodList.data?.isFasting == boolean.True
                                    ? ChangeMenuType.Original
                                    : ChangeMenuType.Fasting, loadingSnapshot.requireData, snapshot.requireData)),
                      ],
                    );
                  },
                );
              return EmptyBox();
            },
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  bool isTodayOrAfter(WeekDay weekDay) {
    return weekDay.gregorianDate.isAfter(
            DateTime.parse(DateTime.now().toString().substring(0, 10))) ||
        weekDay.gregorianDate.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10);
  }

  Widget item(ChangeMenuType type, bool isLoading, WeekDay weekDay) {
    if (type == ChangeMenuType.Original) fastBloc = FastBloc();
    return GestureDetector(
      onTap: () => type == ChangeMenuType.DailyMenu
          ? dailyMenuDialog(weekDay)
          : type == ChangeMenuType.Original
              ? originalDialog(isLoading)
              : fastDialog(),
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.menu,
                size: 6.w,
              ),
              Space(width: 2.w),
              Text(
                type == ChangeMenuType.DailyMenu
                    ? intl.selectDailyMenu
                    : type == ChangeMenuType.Original
                        ? intl.fast
                        : intl.iFastToday,
                style: typography.caption,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void dailyMenuDialog(WeekDay weekDay) {
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
                intl.selectDailyMenu,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                intl.selectAllFoodYourself,
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 1.h),
              Container(
                alignment: Alignment.center,
                child: SubmitButton(
                  onTap: () {
                    Navigator.of(context).pop();
                    VxNavigator.of(context).push(Uri(path: Routes.dailyMenu));
                  },
                  label: intl.yesGoToSelectFoodPage,
                ),
              ),
              Space(height: 1.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  intl.cancel,
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

  void fastDialog() {
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
                intl.fastingModel,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                intl.convertToFast,
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 1.h),
              Container(
                alignment: Alignment.center,
                child: StreamBuilder(
                  stream: bloc.date,
                  builder: (_, AsyncSnapshot<String> snapshot) {
                    return SubmitButton(
                      onTap: () {
                        Navigator.of(context).pop();
                        VxNavigator.of(context)
                            .waitAndPush(Uri(path: Routes.fastPatterns),
                                params: snapshot.requireData)
                            .then((value) {
                          debugPrint('callback ${value}');
                          if (value) bloc.onRefresh(invalidate: true);
                        });
                      },
                      label: intl.iFast,
                    );
                  },
                ),
              ),
              Space(height: 1.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  intl.iRegret,
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

  void originalDialog(bool isLoading) {
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
                intl.fastingModel,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                intl.youSeeFastingPatterns,
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 1.h),
              StreamBuilder(
                stream: bloc.date,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  return Column(
                    children: [
                      Container(
                        width: 50.w,
                        child: SubmitButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            VxNavigator.of(context)
                                .waitAndPush(Uri(path: Routes.fastPatterns),
                                    params: snapshot.requireData)
                                .then((value) {
                              debugPrint('callback ${value}');
                              if (value) bloc.onRefresh(invalidate: true);
                            });
                          },
                          label: intl.changePattern,
                        ),
                      ),
                      // Space(height: 2.h),
                      Container(
                        width: 50.w,
                        child: SubmitButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            fastBloc!.changeToOriginal();
                            debugPrint('i do not fast');
                            if(!isLoading) bloc.onRefresh(invalidate: true);
                          },
                          label: intl.iDoNotFast,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Space(height: 2.h),
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
