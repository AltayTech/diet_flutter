import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/diet_preferences.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/complete_info/bloc.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class CompleteInformationScreen extends StatefulWidget {
  const CompleteInformationScreen({Key? key}) : super(key: key);

  @override
  _CompleteInformationScreenState createState() => _CompleteInformationScreenState();
}

class _CompleteInformationScreenState extends ResourcefulState<CompleteInformationScreen> {
  late CompleteInformationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = CompleteInformationBloc();
    bloc.getDietPreferences();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).push(Uri.parse('/$event'));
    });

    bloc.popDialog.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.completeInformation),
      body: body(),
    );
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
          color: Colors.white,
          child: StreamBuilder(
              stream: bloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == false) {
                  /*controller.text =
                      sicknessBloc.userSickness?.sicknessNote ?? '';*/
                  return content();
                } else {
                  return Container(height: 80.h, child: Progress());
                }
              }),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          child: StreamBuilder<DietPreferences>(
              stream: bloc.dietPreferences,
              builder: (context, dietPreferences) {
                if (dietPreferences.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        intl.completeInformation,
                        textAlign: TextAlign.start,
                        style: typography.subtitle1!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        intl.thisInfoHelpUsToGetYouDiet,
                        textAlign: TextAlign.start,
                        style: typography.caption!
                            .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
                      ),
                      Space(height: 2.h),
                      // pregnancy week
                      dietPreferences.requireData.hasPregnancyDiet! ? pregnancyWeek() : Container(),//Container(),
                      Space(height: 2.h),
                      // diet goals
                      dietPreferences.requireData.dietGoal!.length > 0
                          ? boxGoal(
                              intl.whatIsYourGoal,
                              dietPreferences.requireData.dietGoal!,
                            )
                          : Container(child: Text(intl.emptyDietGoals, style: typography.caption)),
                      // diet history
                      dietPreferences.requireData.dietHistories!.length > 0
                          ? boxHistory(
                              intl.haveYouEverBeenOnDiet,
                              dietPreferences.requireData.dietHistories!,
                            )
                          : Container(
                              child: Text(intl.emptyDietHistory, style: typography.caption)),
                      // diet activity
                      dietPreferences.requireData.activityLevels!.length > 0
                          ? boxActivity(
                              intl.howMuchIsYourDailyActivity,
                              dietPreferences.requireData.activityLevels!,
                            )
                          : Container(
                              child: Text(intl.emptyDietActivity, style: typography.caption)),
                      Space(height: 1.h),
                      CustomButton.withIcon(AppColors.btnColor, intl.confirmContinue,
                          Size(100.w, 6.h), Icon(Icons.arrow_forward), () {
                        if (bloc.selectedActivity != null &&
                            bloc.selectedDietHistoryValue != null &&
                            bloc.selectedGoalValue != null) {
                          DialogUtils.showDialogProgress(context: context);
                          bloc.updateDietPreferences();
                        } else {
                          Utils.getSnackbarMessage(context, intl.errorCompleteInfo);
                        }
                      })
                    ],
                  );
                } else {
                  return Container(height: 60.h, child: Progress());
                }
              }),
        )
      ],
    );
  }

  Widget pregnancyWeek() {
    return Container(
        width: double.maxFinite,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(intl.howManyPregnancyWeek,
                style: typography.caption!.copyWith(fontWeight: FontWeight.bold)),
            Space(height: 2.h),
            Container(
              height: 7.h,
              padding: EdgeInsets.all(1.w),
              decoration: BoxDecoration(
                color: AppColors.onPrimary,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.redBar.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(15)
                            ),
                            child: IconButton(
                                color: AppColors.redBar,
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.add),
                                iconSize: 20,
                                onPressed: () {
                                  if (bloc.pregnancyWeek >= 1 && bloc.pregnancyWeek <= 34) {
                                    setState(() {
                                      bloc.pregnancyWeek++;
                                    });
                                  }
                                }),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              '${bloc.pregnancyWeek}',
                              textAlign: TextAlign.center,
                              softWrap: false,
                              style: typography.caption?.apply(
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            decoration: BoxDecoration(
                                color: AppColors.redBar.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: IconButton(
                                color: AppColors.redBar,
                                padding: EdgeInsets.zero,
                                icon: Icon(Icons.remove),
                                iconSize: 20,
                                onPressed: () {
                                  if (bloc.pregnancyWeek >= 1 && bloc.pregnancyWeek <= 34) {
                                    setState(() {
                                      bloc.pregnancyWeek--;
                                    });
                                  }
                                }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Widget boxGoal(String title, List<DietGoal> DietGoalListData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: DietGoalListData.length,
                itemBuilder: (BuildContext context, int index) => StreamBuilder<DietGoal?>(
                    stream: bloc.selectedGoal,
                    builder: (context, selectedDietGoal) {
                      if (selectedDietGoal.hasData)
                        return boxGoalItem(DietGoalListData[index],
                            DietGoalListData[index].id == selectedDietGoal.data!.id);
                      return boxGoalItem(DietGoalListData[index], false);
                    }))),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(title,
                          style: typography.caption!.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
              Space(height: 2.h),
              Container(
                height: 1.5,
                color: Colors.grey.withOpacity(0.2),
              )
            ])),
        collapsed: Container(),
      ),
    );
  }

  Widget boxGoalItem(DietGoal dietGoal, bool selected) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CheckBoxApp(
          maxHeight: 5.h,
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {
            bloc.onDietGoalClick(dietGoal);
          },
          title: dietGoal.title,
          isSelected: selected,
        ));
  }

  Widget boxHistory(String title, List<DietHistory> DietHistoryListData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: DietHistoryListData.length,
                itemBuilder: (BuildContext context, int index) => StreamBuilder<DietHistory?>(
                    stream: bloc.selectedDietHistory,
                    builder: (context, selectedDietHistory) {
                      if (selectedDietHistory.hasData)
                        return boxHistoryItem(DietHistoryListData[index],
                            DietHistoryListData[index].id == selectedDietHistory.data!.id);
                      return boxHistoryItem(DietHistoryListData[index], false);
                    }))),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(title,
                          style: typography.caption!.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
              Space(height: 2.h),
              Container(
                height: 1.5,
                color: Colors.grey.withOpacity(0.2),
              )
            ])),
        collapsed: Container(),
      ),
    );
  }

  Widget boxHistoryItem(DietHistory dietHistory, bool selected) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CheckBoxApp(
          maxHeight: 5.h,
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {
            bloc.onDietHistoryClick(dietHistory);
          },
          title: dietHistory.title,
          isSelected: selected,
        ));
  }

  Widget boxActivity(String title, List<ActivityData> ActivityListData) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: ActivityListData.length,
                itemBuilder: (BuildContext context, int index) => StreamBuilder<ActivityData?>(
                    stream: bloc.selectedActivityLevel,
                    builder: (context, selectedActivityLevel) {
                      if (selectedActivityLevel.hasData)
                        return boxActivityItem(ActivityListData[index],
                            ActivityListData[index].id == selectedActivityLevel.data!.id);
                      return boxActivityItem(ActivityListData[index], false);
                    }))),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius:
                    BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                      child: Text(title,
                          style: typography.caption!.copyWith(fontWeight: FontWeight.bold))),
                ],
              ),
            ])),
        collapsed: Container(),
      ),
    );
  }

  Widget boxActivityItem(ActivityData activityData, bool selected) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: CheckBoxApp.description(
          maxHeight: activityData.description!.length > 85
              ? 14.h
              : activityData.description!.length > 50
                  ? 12.h
                  : 10.h,
          description: activityData.description!,
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {
            bloc.onActivityLevelClick(activityData);
          },
          title: activityData.title,
          isSelected: selected,
        ));
  }

  @override
  void onRetryLoadingPage() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    bloc.onRetryLoadingPage();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}
