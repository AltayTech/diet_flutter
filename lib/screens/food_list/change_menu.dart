import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/screens/fast/bloc.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';
import 'provider.dart';
import 'week_day.dart';

enum ChangeMenuType {
  DailyMenu,
  Fasting,
  ChangePatten,
  Original,
  CancelFastTrack,
  CancelFastTrackDisable
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
                    debugPrint('regime type ${snapshotFoodList.data?.dietType?.alias}');
                    return Column(
                      children: [
                        SizedBox(
                          width: 50.w,
                          child: MaterialButton(
                            onPressed: () {
                              VxNavigator.of(context)
                                  .push(Uri.parse(Routes.helpType), params: HelpPage.fasting);
                            },
                            shape: AppShapes.rectangleMedium,
                            color: AppColors.helpFastingButton,
                            disabledElevation: 0,
                            disabledColor: Color.fromRGBO(225, 225, 225, 1.0),
                            elevation: 1,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.help_outline_rounded,
                                    size: 6.w,
                                    color: Colors.white,
                                  ),
                                  Space(width: 2.w),
                                  Text(
                                    intl.helpFasting,
                                    style: typography.caption!.copyWith(color: Colors.white),
                                    softWrap: true,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            snapshotFoodList.data?.dietType?.alias == RegimeAlias.Pregnancy
                                ? item(ChangeMenuType.DailyMenu, loadingSnapshot.requireData,
                                    snapshot.requireData, Icons.menu)
                                : Expanded(
                                    flex: 1,
                                    child: item(
                                        ChangeMenuType.DailyMenu,
                                        loadingSnapshot.requireData,
                                        snapshot.requireData,
                                        Icons.menu),
                                  ),
                            if (snapshotFoodList.data?.dietType?.alias != RegimeAlias.Pregnancy &&
                                snapshotFoodList.data?.menu?.theme != TypeTheme.FASTING &&
                                snapshotFoodList.data?.menu?.theme != TypeTheme.FASTING2)
                              Expanded(
                                flex: 1,
                                child: item(
                                    snapshotFoodList.data?.isFasting == boolean.True
                                        ? ChangeMenuType.Original
                                        : ChangeMenuType.Fasting,
                                    loadingSnapshot.requireData,
                                    snapshot.requireData,
                                    Icons.menu),
                              ),
                            if (snapshotFoodList.data?.menu?.theme == TypeTheme.FASTING ||
                                snapshotFoodList.data?.menu?.theme == TypeTheme.FASTING2)
                              Expanded(
                                flex: 1,
                                child: item(
                                    snapshotFoodList.data?.menu?.theme == TypeTheme.FASTING2
                                        ? ChangeMenuType.CancelFastTrack
                                        : ChangeMenuType.CancelFastTrackDisable,
                                    loadingSnapshot.requireData,
                                    snapshot.requireData,
                                    Icons.close_rounded),
                              ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              return EmptyBox();
            },
          );
        return Center(child: Progress());
      },
    );
  }

  bool isTodayOrAfter(WeekDay weekDay) {
    return weekDay.gregorianDate
            .isAfter(DateTime.parse(DateTime.now().toString().substring(0, 10))) ||
        weekDay.gregorianDate.toString().substring(0, 10) ==
            DateTime.now().toString().substring(0, 10);
  }

  Widget item(ChangeMenuType type, bool isLoading, WeekDay weekDay, IconData icon) {
    if (type == ChangeMenuType.Original || type == ChangeMenuType.CancelFastTrack)
      fastBloc = FastBloc();
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w),
      child: MaterialButton(
        onPressed: () => type == ChangeMenuType.DailyMenu
            ? dailyMenuDialog(weekDay)
            : type == ChangeMenuType.Original
                ? originalDialog(isLoading)
                : type == ChangeMenuType.CancelFastTrackDisable
                    ? null
                    : type == ChangeMenuType.CancelFastTrack
                        ? cancelFastingDialog(isLoading)
                        : fastDialog(),
        shape: AppShapes.rectangleMedium,
        color: type == ChangeMenuType.CancelFastTrackDisable
            ? Color.fromRGBO(241, 244, 246, 1.0)
            : Colors.white,
        disabledElevation: 0,
        disabledColor: Color.fromRGBO(225, 225, 225, 1.0),
        elevation: 1,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 1.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 6.w,
                color: type == ChangeMenuType.CancelFastTrackDisable
                    ? Color.fromRGBO(172, 172, 172, 1.0)
                    : null,
              ),
              Space(width: 2.w),
              Text(
                type == ChangeMenuType.DailyMenu
                    ? intl.selectDailyMenu
                    : type == ChangeMenuType.Original
                        ? intl.fast
                        : (type == ChangeMenuType.CancelFastTrack ||
                                type == ChangeMenuType.CancelFastTrackDisable)
                            ? intl.cancelFasting
                            : intl.iFastToday,
                style: typography.caption!.copyWith(
                    color: type == ChangeMenuType.CancelFastTrackDisable
                        ? Color.fromRGBO(172, 172, 172, 1.0)
                        : null),
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
            mainAxisAlignment: MainAxisAlignment.start,
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
                  onTap: () async {
                    Navigator.of(context).pop();
                    var result = await VxNavigator.of(context)
                        .push(Uri(path: Routes.dailyMenu), params: bloc)
                        .then((value) {
                      debugPrint('call back }');
                      // if(value != null && value == true) bloc.onRefresh(invalidate: true);
                    });
                    debugPrint('call back 2 ${result}');
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
              Space(height: 1.h),
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
                      Space(height: 2.h),
                      Container(
                        width: 50.w,
                        child: SubmitButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            fastBloc!.changeToOriginal(snapshot.requireData);
                            debugPrint('i do not fast');
                            if (!isLoading) bloc.onRefresh(invalidate: true);
                            // (context as Element).markNeedsBuild();
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

  void cancelFastingDialog(bool isLoading) {
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
                intl.fastTrackModel,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              StreamBuilder(
                stream: bloc.date,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  if(snapshot.hasData)
                  return Column(
                    children: [
                      Text(
                        intl.cancelFastTrackModel(
                            DateTimeUtils.gregorianToJalali(snapshot.requireData)),
                        style: typography.caption,
                        textAlign: TextAlign.center,
                      ),
                      Space(height: 1.h),
                      Container(
                        width: 50.w,
                        child: SubmitButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            fastBloc!.changeToOriginal(snapshot.requireData);
                            //  debugPrint('i do not fast');
                            if (!isLoading) bloc.onRefresh(invalidate: true);
                          },
                          label: intl.cancelFasting,
                        ),
                      ),
                      Space(height: 2.h),
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Text(
                          intl.iRegret,
                          style: typography.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                  else return Progress();
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

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
