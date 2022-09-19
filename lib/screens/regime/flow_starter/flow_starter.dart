import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/flow_starter/bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

class FlowStarterScreen extends StatefulWidget {
  const FlowStarterScreen({Key? key}) : super(key: key);

  @override
  _FlowStarterScreenState createState() => _FlowStarterScreenState();
}

class _FlowStarterScreenState extends ResourcefulState<FlowStarterScreen> {
  late FlowStarterBloc bloc;

  @override
  void initState() {
    super.initState();
    MemoryApp.page = 0;
    bloc = FlowStarterBloc();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      VxNavigator.of(context).push(Uri.parse('/$event'));
    });

    bloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });

    bloc.popDialog.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.foodList),
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: Container(
        height: 100.h,
        child: Stack(alignment: Alignment.center, children: [
          Container(
            height: 70.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ImageUtils.fromLocal('assets/images/diet/fill_data.png',
                    width: 60.w, height: 60.w, fit: BoxFit.fill),
                Space(height: 4.h),
                Text(
                  intl.fillYourInformation,
                  textAlign: TextAlign.center,
                  textDirection: context.textDirectionOfLocale,
                  style: typography.subtitle1!.copyWith(fontWeight: FontWeight.bold),
                ),
                Space(height: 1.h),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: Text(
                    intl.getFoodProgramDescription,
                    textAlign: TextAlign.center,
                    textDirection: context.textDirectionOfLocale,
                    style: typography.caption!.copyWith(fontSize: 10.sp),
                  ),
                ),
                Space(height: 4.h),
                Padding(
                  padding: const EdgeInsets.only(right: 32, left: 32),
                  child: CustomButton.withIcon(AppColors.btnColor, intl.getFoodProgram,
                      Size(100.w, 6.h), Icon(Icons.arrow_forward), () {
                    DialogUtils.showDialogProgress(context: context);
                    bloc.nextStep();
                  }),
                ),
              ],
            ),
          ),
          Positioned(bottom: 0, child: BottomNav(currentTab: BottomNavItem.DIET))
        ]),
      ),
    );
  }

  Widget header() {
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Space(height: 1.h),
        Container(
          width: 100.w,
          alignment: Alignment.center,
          child: ProgressTimeline(
              width: 50.w,
              height: 7.h,
              failedIcon: Icon(Icons.cancel),
              checkedIcon: Icon(Icons.check_circle),
              uncheckedIcon: Icon(Icons.circle_outlined),
              currentIcon: Icon(
                Icons.radio_button_checked_rounded,
                color: AppColors.primary,
              ),
              connectorWidth: 1.w,
              iconSize: 7.w,
              connectorLength: 15.w,
              connectorColor: AppColors.grey,
              connectorColorSelected: AppColors.primary,
              states: [
                SingleState(stateTitle: "", isFailed: false),
                SingleState(stateTitle: "", isFailed: false),
                SingleState(stateTitle: "", isFailed: false),
                SingleState(stateTitle: "", isFailed: false)
              ]),
        ),
        Space(height: 2.h),
        Text(
          intl.statusReport,
          textDirection: context.textDirectionOfLocale,
          style: typography.subtitle1!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          intl.thisIsFirstStatusReport,
          textDirection: context.textDirectionOfLocale,
          style: typography.caption!.copyWith(fontSize: 10.sp),
        ),
      ]),
    );
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    bloc.onRetryAfterNoInternet();
  }

  @override
  void onRetryLoadingPage() {}
}
