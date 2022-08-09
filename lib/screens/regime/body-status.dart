import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class BodyStatusScreen extends StatefulWidget {
  const BodyStatusScreen({Key? key}) : super(key: key);

  @override
  _BodyStatusScreenState createState() => _BodyStatusScreenState();
}

class _BodyStatusScreenState extends ResourcefulState<BodyStatusScreen> {
  late RegimeBloc regimeBloc;

  @override
  void initState() {
    super.initState();
    regimeBloc = RegimeBloc();
    regimeBloc.getStatus();
    regimeBloc.physicalInfoData();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.navigateToVerify.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      context.vxNav.push(Uri.parse('/${event}'));
    });
    regimeBloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  void dispose() {
    regimeBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.statusReport),
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: StreamBuilder(
          stream: regimeBloc.status,
          builder: (context, AsyncSnapshot<BodyStatus> snapshot) {
            if (snapshot.hasData) {
              return TouchMouseScrollable(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      header(),
                      Space(height: 3.h),
                      snapshot.data!.isPregnancy == 1
                          ? showWeightBmi(
                              snapshot.data!.daysTillChildbirth,
                              snapshot.data!.pregnancyWeightDiff!
                                  .toStringAsFixed(1),
                              snapshot.data!.pregnancyWeight!
                                  .toStringAsFixed(1),
                              snapshot.data!.isPregnancy,
                              snapshot.data!.bmiStatus,
                              snapshot.data!.bmi!.toStringAsFixed(0))
                          : showWeightBmi(
                              snapshot.data!.dietDays,
                              snapshot.data!.weightDifference!
                                  .toStringAsFixed(1),
                              snapshot.data!.normalWeight!
                                  .toStringAsFixed(1),
                              snapshot.data!.isPregnancy,
                              snapshot.data!.bmiStatus,
                              snapshot.data!.bmi!.toStringAsFixed(0)),
                      Space(height: 2.h),
                      dietType(),
                      Space(height: 2.h),
                      helpDietSelect(),
                      Space(height: 2.h),
                      Padding(
                        padding: const EdgeInsets.only(right: 32, left: 32),
                        child: CustomButton.withIcon(
                            AppColors.btnColor,
                            intl.nextStage,
                            Size(100.w, 6.h),
                            Icon(Icons.arrow_forward),
                            () {}),
                      )
                    ],
                  ),
                ),
              );
            } else
              return Center(
                  child:
                      Container(width: 15.w, height: 15.w, child: Progress()));
          }),
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

  Widget showWeightBmi(int? dietDays, String? weightDiff, String? weight,
      int? pregnancy, int? bmiStatus, String? bmi) {
    return Container(
      height: 33.h,
      padding: EdgeInsets.only(right: 32, left: 32),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (pregnancy == 0)
                        bmiStatus == 0
                            ? colorfulContainer('$weightDiff', intl.lakeWeight,
                                intl.kiloGr, '', AppColors.purpleRuler)
                            : colorfulContainer('$weightDiff', intl.extraWeight,
                                intl.kiloGr, '', AppColors.purpleRuler),
                      if (pregnancy == 1)
                        colorfulContainer('$weightDiff', intl.getWeight,
                            intl.kiloGr, '', AppColors.pregnantPink),
                      Space(height: 1.h),
                      Container(
                        width: 40.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: AppColors.grey.withOpacity(0.5),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(intl.bmi,
                                  style: typography.caption!.copyWith(
                                      color: Colors.grey.withOpacity(0.9))),
                              Text('BMI',
                                  style: typography.caption!.copyWith(
                                      color: Colors.grey.withOpacity(0.9))),
                              Container(
                                width: 30.w,
                                height: 7.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: Colors.white),
                                child: Center(
                                    child: Text(
                                  '$bmi',
                                  style: typography.caption!.copyWith(
                                      color: AppColors.redBar,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16.sp),
                                )),
                              )
                            ],
                          ),
                        ),
                      ),
                      Space(height: 1.h),
                      InkWell(
                        onTap: () => DialogUtils.showDialogPage(
                          context: context,
                          child: HelpDialog(helpId: 1),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: AppColors.redBar)),
                          child: Container(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('BMI',
                                    style: typography.caption!
                                        .copyWith(color: AppColors.redBar)),
                                Space(width: 1.w),
                                Text(intl.what,
                                    style: typography.caption!
                                        .copyWith(color: AppColors.redBar)),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Space(width: 3.w),
              Expanded(
                child: Container(
                  child: bmiPic(bmiStatus),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget colorfulContainer(
      String weight, String txt2, String txt3, String txt4, Color color) {
    return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.weightBoxColor),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(txt2,
                      style: typography.caption!
                          .copyWith(fontSize: 10.sp, color: Colors.white)),
                  RichText(
                    textDirection: context.textDirectionOfLocale,
                    text: TextSpan(
                      text: weight,
                      style: typography.caption!.copyWith(
                          fontSize: 16.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w700),
                      children: <TextSpan>[
                        TextSpan(
                            text: ' ',
                            style: typography.caption!.copyWith(
                                fontSize: 12.sp, color: Colors.white)),
                        TextSpan(
                            text: txt3,
                            style: typography.caption!.copyWith(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                  ),
                  if (txt4.length > 0)
                    Text(txt4,
                        style: typography.caption!
                            .copyWith(fontSize: 10.sp, color: Colors.white))
                ],
              ),
            ),
          )
        ]));
  }

  String bmiPicPath(int? status) {
    switch (status) {
      case 0:
        return 'assets/images/physical_report/thin.svg';
      case 1:
        return 'assets/images/physical_report/normal.svg';
      case 2:
        return 'assets/images/physical_report/fat.svg';
      case 3:
        return 'assets/images/physical_report/obesity.svg';
      case 4:
        return 'assets/images/physical_report/extreme_obesity.svg';
      case 5:
        return 'assets/images/physical_report/extreme_obesity.svg';
      default:
        return 'assets/images/physical_report/extreme_obesity.svg';
    }
  }

  Widget bmiPic(int? status) {
    return ImageUtils.fromLocal(bmiPicPath(status),
        width: 40.w, height: 33.h, fit: BoxFit.fill);
  }

  Widget dietType() {
    return Container(
      margin: EdgeInsets.only(right: 32, left: 32),
      height: 20.h,
      decoration: BoxDecoration(
          color: AppColors.dietTypeBoxColor.withOpacity(0.08),
          border: Border.all(color: AppColors.dietTypeBoxColor, width: 1),
          boxShadow: [
            BoxShadow(
                color: AppColors.priceGreenColor.withOpacity(0.08),
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(1, 1))
          ],
          borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                top: 2,
                bottom: 2,
                right: 2,
                left: 2,
                child: ImageUtils.fromLocal("assets/images/diet/spoon_fork.svg",
                    width: 10.w,
                    height: 10.h,
                    fit: BoxFit.contain),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 48),
                child: Text(
                  intl.dietsSuitableYou,
                  style: typography.caption,
                ),
              )
            ],
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Space(width: 3.w),
          Expanded(
            child: CheckBoxApp(
                isBorder: false,
                iconSelectType: IconSelectType.Radio,
                onTap: () {},
                title: 'رژیم کاهش وزن',
                isSelected: true),
          ),
          Space(width: 3.w),
          Expanded(
            child: CheckBoxApp(
                isBorder: false,
                iconSelectType: IconSelectType.Radio,
                onTap: () {},
                title: 'رژیم تثبیت',
                isSelected: false),
          ),
          Space(width: 3.w),
        ]),
        Space(height: 1.h)
      ]),
    );
  }

  Widget helpDietSelect() {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(right: 32, left: 32),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Space(height: 1.h),
          Text(
            intl.whichDietShouldITake,
            textDirection: context.textDirectionOfLocale,
            style: typography.caption!.copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            intl.thisIsFirstStatusReport,
            textDirection: context.textDirectionOfLocale,
            style: typography.caption!.copyWith(fontSize: 10.sp),
          ),
        ]),
      ),
    );
  }

  void pregnancyWeekAlert() {
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
                '',
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                intl.pregnancyWeekAlertDesc(
                    regimeBloc.bodyStatus.allowedWeeksNum!),
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Container(
                alignment: Alignment.center,
                child: SubmitButton(
                  onTap: () async {
                    Navigator.of(context).pop();
                    DialogUtils.showDialogProgress(context: context);
                    regimeBloc.nextStep();
                  },
                  label: intl.understandGoToNext,
                ),
              ),
              Space(height: 2.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  intl.cancel,
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

  void sendRequest({required bool isPregnancy}) {
    if (isPregnancy) {
      pregnancyWeekAlert();
    } else {
      if (!MemoryApp.isShowDialog)
        DialogUtils.showDialogProgress(context: context);
      regimeBloc.nextStep();
    }
  }

  @override
  void onRetryAfterNoInternet() {
    sendRequest(isPregnancy: false);
  }

  @override
  void onRetryLoadingPage() {
    regimeBloc.getStatus();
    regimeBloc.physicalInfoData();
  }
}
