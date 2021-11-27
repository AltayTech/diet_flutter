import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/overview.dart';
import 'package:behandam/screens/regime/diet_hostory/bloc.dart';
import 'package:behandam/screens/regime/overview/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';
import 'package:velocity_x/velocity_x.dart';

class OverviewPage extends StatefulWidget {
  const OverviewPage({Key? key}) : super(key: key);

  @override
  _OverviewPageState createState() => _OverviewPageState();
}

class _OverviewPageState extends ResourcefulState<OverviewPage> {
  late OverviewBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = OverviewBloc();
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
      appBar: Toolbar(titleBar: intl.stateOfBody),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: StreamBuilder(
              stream: bloc.dietHistory,
              builder: (_, AsyncSnapshot<OverviewData> snapshot) {
                if (snapshot.hasData)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        intl.aGlanceToBodyState,
                        style: typography.caption,
                        textAlign: TextAlign.center,
                      ),
                      Space(height: 2.h),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: item(
                              snapshot.requireData.activityLevel,
                              intl.physicalActivity,
                            ),
                          ),
                          Space(width: 3.w),
                          Expanded(
                            flex: 1,
                            child: item(snapshot.requireData.dietHistory,
                                intl.dietHistory),
                          ),
                        ],
                      ),
                      Space(height: 2.h),
                      item(snapshot.requireData.dietGoal, intl.dietGoal),
                      Center(
                        child: SubmitButton(
                          label: intl.viewFoodList,
                          onTap: () {
                            DialogUtils.showDialogProgress(context: context);
                            if (!bloc.path.isEmptyOrNull)
                              VxNavigator.of(context)
                                  .push(Uri(path: '/${bloc.path}'));
                          },
                        ),
                      ),
                      Space(height: 2.h),
                      TextButton(
                        onPressed: () {
                          if(VxNavigator.of(context).pages.length > 1)
                          VxNavigator.of(context).pop();
                        },
                        child: Text(
                          intl.editPhysicalInfo,
                          style: typography.caption?.apply(
                            color: AppColors.labelColor,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
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

  Widget item(dynamic item, String header) {
    return Column(
      children: [
        Text(
          header,
          style: typography.caption?.apply(
            color: AppColors.labelColor,
          ),
          textAlign: TextAlign.center,
        ),
        Container(
          decoration: AppDecorations.boxMedium.copyWith(
            color: AppColors.greenRuler,
          ),
          height: 10.h,
          margin: EdgeInsets.only(bottom: 2.h),
          child: Container(
            margin: EdgeInsets.only(right: 3.w),
            decoration: BoxDecoration(
              color: AppColors.box,
              borderRadius: BorderRadius.only(
                bottomLeft: AppRadius.radiusMedium,
                topLeft: AppRadius.radiusMedium,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
            child: Center(
              child: Text(
                item?.title ?? '',
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
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
