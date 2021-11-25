import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import 'bloc.dart';

class ActivityLevelPage extends StatefulWidget {
  const ActivityLevelPage({Key? key}) : super(key: key);

  @override
  _ActivityLevelPageState createState() => _ActivityLevelPageState();
}

class _ActivityLevelPageState extends ResourcefulState<ActivityLevelPage> {
  late ActivityBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = ActivityBloc();
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      context.vxNav.push(Uri.parse('/$event'));
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.activityLevel),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: StreamBuilder(
              stream: bloc.activityLevel,
              builder: (_, AsyncSnapshot<ActivityLevelData> snapshot) {
                if (snapshot.hasData)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        intl.howMuchIsYourDailyActivity,
                        style: typography.caption,
                        textAlign: TextAlign.center,
                      ),
                      Space(height: 2.h),
                      ...snapshot.requireData.items
                          .map((activity) => item(activity))
                          .toList(),
                      Center(child: SubmitButton(label: intl.nextStage, onTap: () {
                        DialogUtils.showDialogProgress(context: context);
                        bloc.condition();
                      })),
                    ],
                  );
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget item(ActivityData activity) {
    return StreamBuilder(
      stream: bloc.selectedActivityLevel,
      builder: (_, AsyncSnapshot<ActivityData?> snapshot) {
        return GestureDetector(
          onTap: () => bloc.onActivityLevelClick(activity),
          child: Container(
            decoration: AppDecorations.boxMedium.copyWith(
              color: AppColors.greenRuler,
              boxShadow:
                  snapshot.hasData && snapshot.requireData!.id == activity.id
                      ? [
                          BoxShadow(
                            color: AppColors.greenRuler,
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                          ),
                        ]
                      : null,
            ),
            margin: EdgeInsets.only(bottom: 2.h),
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color: snapshot.hasData && snapshot.requireData!.id == activity.id
                    ? AppColors.onPrimary
                    : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: AppRadius.radiusMedium,
                  topLeft: AppRadius.radiusMedium,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: typography.subtitle2,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    activity.description ?? '',
                    style: typography.caption?.apply(
                      color: AppColors.labelColor,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
