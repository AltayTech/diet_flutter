import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
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
      body: SafeArea(
        child: StreamBuilder(
            stream: regimeBloc.status,
            builder: (context, AsyncSnapshot<BodyStatus> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TouchMouseScrollable(
                        child: SingleChildScrollView(
                          child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  snapshot.data!.isPregnancy == 1
                                      ? firstContainer(
                                          snapshot.data!.daysTillChildbirth,
                                          snapshot.data!.pregnancyWeightDiff!.toStringAsFixed(1),
                                          snapshot.data!.pregnancyWeight!.toStringAsFixed(1),
                                          snapshot.data!.isPregnancy,
                                          snapshot.data!.bmiStatus)
                                      : firstContainer(
                                          snapshot.data!.dietDays,
                                          snapshot.data!.weightDifference!.toStringAsFixed(1),
                                          snapshot.data!.normalWeight!.toStringAsFixed(1),
                                          snapshot.data!.isPregnancy,
                                          snapshot.data!.bmiStatus),
                                  SizedBox(height: 2.h),
                                  secondContainer(snapshot.data!.bmi!.toStringAsFixed(0),
                                      snapshot.data!.bmiStatus),
                                  GestureDetector(
                                    onTap: () {
                                      sendRequest(isPregnancy: snapshot.data!.isPregnancy == 1);
                                    },
                                    child: snapshot.data!.isPregnancy == 1
                                        ? ImageUtils.fromLocal(
                                            'assets/images/physical_report/banner_pregnant.svg',
                                            height: 15.h)
                                        : ImageUtils.fromLocal(
                                            'assets/images/physical_report/banner.svg',
                                            height: 15.h),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: SubmitButton(
                          label: intl.confirmContinue,
                          onTap: () {
                            sendRequest(isPregnancy: snapshot.data!.isPregnancy == 1);
                          }),
                    ),
                  ],
                );
              } else
                return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
            }),
      ),
    );
  }

  Widget firstContainer(
      int? dietDays, String? weightDiff, String? weight, int? pregnancy, int? bmiStatus) {
    return Container(
      padding: EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 5,
                child: Row(
                  textDirection: context.textDirectionOfLocale,
                  children: [
                    pregnancy == 1
                        ? ImageUtils.fromLocal('assets/images/physical_report/element1.svg',
                            width: 10.w, height: 15.w)
                        : Container(),
                    pregnancy == 1
                        ? ImageUtils.fromLocal('assets/images/physical_report/element2.svg',
                            width: 10.w, height: 15.w)
                        : Container(),
                  ],
                )),
            Positioned(
                top: 0,
                left: 0,
                child: Row(
                  textDirection: context.textDirectionOfLocale,
                  children: [
                    pregnancy == 1
                        ? ImageUtils.fromLocal('assets/images/physical_report/element3.svg',
                            width: 10.w, height: 15.w)
                        : Container(),
                    pregnancy == 1
                        ? ImageUtils.fromLocal('assets/images/physical_report/element4.svg',
                            width: 10.w, height: 15.w)
                        : Container(),
                  ],
                )),
            Column(
              children: [
                Space(height: 2.h),
                Center(
                  child: Text(
                    intl.firstStatusReport,
                    textDirection: context.textDirectionOfLocale,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: AppColors.box,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          pregnancy == 1
                              ? colorfulContainer('$dietDays', intl.day, intl.untilBeingMom, ' ',
                                  AppColors.pregnantPink)
                              : colorfulContainer('$dietDays', intl.day, intl.untilReach,
                                  intl.appropriateWeight, AppColors.purpleRuler),
                          SizedBox(height: 2.h),
                          if (pregnancy == 0)
                            bmiStatus == 0
                                ? colorfulContainer('$weightDiff', intl.kilo, intl.lakeWeight, '',
                                    AppColors.purpleRuler)
                                : colorfulContainer('$weightDiff', intl.kilo, intl.extraWeight, '',
                                    AppColors.purpleRuler),
                          if (pregnancy == 1)
                            colorfulContainer('$weightDiff', intl.kilo, intl.getWeight, '',
                                AppColors.pregnantPink),
                        ],
                      ),
                    ),
                    Space(width: 2.w),
                    Column(
                      children: [
                        Container(
                          width: 40.w,
                          height: 30.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: AppColors.box,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              pregnancy == 1
                                  ? Text(intl.appropriateWeightPregnancy,
                                      textAlign: TextAlign.center)
                                  : Text(intl.yourAppropriateWeight, textAlign: TextAlign.center),
                              SizedBox(height: 1.h),
                              Container(
                                width: 30.w,
                                // height: 9.h,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0), color: Colors.white),
                                child: Center(
                                    child: Column(
                                  children: [
                                    Text('${weight}',
                                        style: TextStyle(
                                            color: AppColors.purpleRuler,
                                            fontWeight: FontWeight.w700)),
                                    Text(intl.kiloGr,
                                        style: TextStyle(color: AppColors.purpleRuler))
                                  ],
                                )),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 12.w,
                          height: 4.h,
                          child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.box,
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(70.0),
                                    bottomRight: Radius.circular(70.0)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: InkWell(
                                  onTap: () => DialogUtils.showDialogPage(
                                      context: context, child: HelpDialog(helpId: 5)),
                                  child: ImageUtils.fromLocal(
                                    'assets/images/diet/help_icon.svg',
                                    color: AppColors.strongPen,
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget colorfulContainer(String txt1, String txt2, String txt3, String txt4, Color color) {
    return Padding(
      padding: const EdgeInsets.only(right: 6.0, left: 6.0),
      child: Container(
          // width: 30.w,
          // height: 10.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(20.0),
                  topLeft: Radius.circular(20.0)),
              color: Colors.white),
          child: Row(children: [
            Container(
                width: 3.w,
                height: 10.h,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                    color: color)),
            // SizedBox(width: 4.w),
            Expanded(
              child: Container(
                // width: 20.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    RichText(
                      textDirection: context.textDirectionOfLocale,
                      text: TextSpan(
                        text: txt1,
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(fontSize: 14.sp, color: color, fontWeight: FontWeight.w700),
                        children: <TextSpan>[
                          TextSpan(
                              text: ' ',
                              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12.0)),
                          TextSpan(
                              text: txt2,
                              style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 12.0))
                        ],
                      ),
                    ),
                    Text(txt3,
                        style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 8.sp)),
                    Text(txt4, style: Theme.of(context).textTheme.caption!.copyWith(fontSize: 8.sp))
                  ],
                ),
              ),
            )
          ])),
    );
  }

  Widget secondContainer(String bmi, int? bmiStatus) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 40.w,
                      height: 30.h,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        color: AppColors.box,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(intl.bmi),
                          Text('BMI'),
                          Container(
                            width: 30.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0), color: Colors.white),
                            child: Center(
                                child: Text(
                              '$bmi',
                              style: Theme.of(context).textTheme.caption!.copyWith(
                                  color: AppColors.blueRuler,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16.sp),
                            )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
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
                          padding: EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              ImageUtils.fromLocal('assets/images/physical_report/bmi.svg',
                                  width: 2.w, height: 2.h),
                              Space(width: 2.w),
                              Text('BMI',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontSize: 14.sp, color: AppColors.redBar)),
                              Space(width: 1.w),
                              Text(intl.what,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontSize: 14.sp, color: AppColors.redBar)),
                              ImageUtils.fromLocal('assets/images/physical_report/guide.svg',
                                  width: 3.w, height: 3.h),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 2.w),
                Flexible(child: bmiPic(bmiStatus)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget bmiPic(int? status) {
    switch (status) {
      case 0:
        return ImageUtils.fromLocal('assets/images/physical_report/thin.svg',
            width: 40.w, height: 30.h);
      case 1:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/normal.svg',
          width: 40.w,
          height: 40.h,
        );
      case 2:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/fat.svg',
          width: 40.w,
          height: 40.h,
        );
      case 3:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/obesity.svg',
          width: 40.w,
          height: 40.h,
        );
      case 4:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 40.h,
        );
      case 5:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 40.h,
        );
      default:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 40.h,
        );
    }
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
                intl.pregnancyWeekAlertDesc(regimeBloc.bodyStatus.allowedWeeksNum!),
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
      if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
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
