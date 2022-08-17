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

import '../../../../data/entity/regime/sickness.dart';

class CompleteInformationScreen extends StatefulWidget {
  const CompleteInformationScreen({Key? key}) : super(key: key);

  @override
  _CompleteInformationScreenState createState() =>
      _CompleteInformationScreenState();
}

class _CompleteInformationScreenState
    extends ResourcefulState<CompleteInformationScreen> implements ItemClick {
  late CompleteInformationBloc bloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = CompleteInformationBloc();
    bloc.getDietPreferences();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      VxNavigator.of(context).push(Uri.parse(event));
    });
    bloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
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
                style: typography.caption!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Space(height: 2.h),
              StreamBuilder<List<DietGoal>>(
                  stream: bloc.dietGoals,
                  builder: (context, dietGoals) {
                    if (dietGoals.hasData) {
                      if (dietGoals.requireData.length > 0) {
                        return box(
                          intl.whatIsYourGoal,
                          dietGoals.requireData,
                        );
                      } else {
                        return Container(
                            child: Text(intl.emptySickness,
                                style: typography.caption));
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
                        return box(
                          intl.haveYouEverBeenOnDiet,
                          dietHistory.requireData,
                        );
                      } else {
                        return Container(
                            child: Text(intl.emptySickness,
                                style: typography.caption));
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
                            child: Text(intl.emptySickness,
                                style: typography.caption));
                      }
                    } else {
                      return Container(height: 60.h, child: Progress());
                    }
                  }),
              Space(height: 1.h),
              CustomButton.withIcon(
                  AppColors.btnColor,
                  intl.confirmContinue,
                  Size(100.w, 6.h),
                  Icon(Icons.arrow_forward),
                  () {})
            ],
          ),
        )
      ],
    );
  }

  Widget box(String title, List<dynamic> ListData) {
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
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: ListData.length,
                itemBuilder: (BuildContext context, int index) =>
                    boxItem(ListData[index]))),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(title, style: typography.caption)),
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

  Widget boxItem(dynamic item) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:  CheckBoxApp(
          maxHeight: 5.h,
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {

          },
          title: item.title!,
          isSelected: false,
        )
    );
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
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: ActivityListData.length,
                itemBuilder: (BuildContext context, int index) =>
                    boxActivityItem(ActivityListData[index]))),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(title, style: typography.caption)),
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

  Widget boxActivityItem(ActivityData activityData) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:  CheckBoxApp.description(
          description: activityData.description!,
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {

          },
          title: activityData.title,
          isSelected: false,
        )
    );
  }

  @override
  void onRetryAfterNoInternet() {}

  @override
  void onRetryLoadingPage() {
    bloc.getDietPreferences();
  }

  @override
  click() {
    setState(() {});
  }

  @override
  void dispose() {
    bloc.dispose();
    controller.dispose();
    super.dispose();
  }
}
