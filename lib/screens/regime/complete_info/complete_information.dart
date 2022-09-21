import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/complete_info/bloc.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';

import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/sickness_dialog.dart';
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
          child: Column(
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
                style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Space(height: 2.h),
              StreamBuilder<List<DietGoal>>(
                  stream: bloc.dietGoals,
                  builder: (context, dietGoals) {
                    if (dietGoals.hasData) {
                      if (dietGoals.requireData.length > 0) {
                        return boxGoal(
                          intl.whatIsYourGoal,
                          dietGoals.requireData,
                        );
                      } else {
                        return Container(
                            child: Text(intl.emptySickness, style: typography.caption));
                      }
                    } else {
                      return Container(height: 60.h, child: Progress());
                    }
                  }),
              StreamBuilder<List<DietHistory>>(
                  stream: bloc.dietHistory,
                  builder: (context, dietHistory) {
                    if (dietHistory.hasData) {
                      if (dietHistory.requireData.length > 0) {
                        return boxHistory(
                          intl.haveYouEverBeenOnDiet,
                          dietHistory.requireData,
                        );
                      } else {
                        return Container(
                            child: Text(intl.emptySickness, style: typography.caption));
                      }
                    } else {
                      return Container(height: 60.h, child: Progress());
                    }
                  }),
              StreamBuilder<List<ActivityData>>(
                  stream: bloc.activityLevel,
                  builder: (context, activity) {
                    if (activity.hasData) {
                      if (activity.requireData.length > 0) {
                        return boxActivity(
                          intl.howMuchIsYourDailyActivity,
                          activity.requireData,
                        );
                      } else {
                        return Container(
                            child: Text(intl.emptySickness, style: typography.caption));
                      }
                    } else {
                      return Container(height: 60.h, child: Progress());
                    }
                  }),
              Space(height: 1.h),
              CustomButton.withIcon(AppColors.btnColor, intl.confirmContinue, Size(100.w, 6.h),
                  Icon(Icons.arrow_forward), () {
                if(bloc.selectedActivity!=null && bloc.selectedDietHistoryValue!=null && bloc.selectedGoalValue!=null) {
                  DialogUtils.showDialogProgress(context: context);
                  bloc.updateDietPreferences();
                }else {
                  Utils.getSnackbarMessage(context, intl.errorCompleteInfo);
                }
              })
            ],
          ),
        )
      ],
    );
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
