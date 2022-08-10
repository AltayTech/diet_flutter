import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/provider.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/regime/ruler_header.dart';
import 'package:behandam/screens/utility/alert.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class ConfirmBodyStateScreen extends StatefulWidget {
  const ConfirmBodyStateScreen({Key? key}) : super(key: key);

  @override
  _ConfirmBodyStateScreenState createState() => _ConfirmBodyStateScreenState();
}

class _ConfirmBodyStateScreenState
    extends ResourcefulState<ConfirmBodyStateScreen> {
  late RegimeBloc regimeBloc;
  bool selectedNo = false;
  bool selectedYes = false;

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
      VxNavigator.of(context).push(
        Uri.parse('/$event'),
      );
    });
    regimeBloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
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

    return RegimeProvider(
      regimeBloc,
      child:
          Scaffold(appBar: Toolbar(titleBar: intl.stateOfBody), body: body()),
    );
  }

  Widget body() {
    return TouchMouseScrollable(
        child: SingleChildScrollView(
            child: StreamBuilder<BodyStatus>(
                stream: regimeBloc.status,
                builder: (context, snapshot) {
                  if (snapshot.hasData)
                    return Container(
                        width: 100.w,
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.w, vertical: 2.h),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Space(height: 2.h),
                              Text(
                                intl.confirmBodyState,
                                textDirection: context.textDirectionOfLocale,
                                style: typography.caption!.copyWith(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                intl.youMustEnterCorrectInfoOfBodyState,
                                textDirection: context.textDirectionOfLocale,
                                style: typography.caption!
                                    .copyWith(fontSize: 10.sp),
                              ),
                              Text(
                                intl.thisInfoVeryImportantToReduceYourWeight,
                                textDirection: context.textDirectionOfLocale,
                                style: typography.caption!
                                    .copyWith(fontSize: 10.sp),
                              ),
                              Space(height: 2.h),
                              bodyInformation(),
                              Space(height: 2.h),
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
                              Space(height: 5.h),
                              SubmitButton(
                                  color: Colors.white,
                                  textColor: AppColors.primary,
                                  label: intl.editPhysicalInfo,
                                  size: Size(100.w, 6.h),
                                  onTap: () {
                                    context.vxNav.push(Uri.parse(Routes.bodyState));
                                  }),
                              Space(height: 2.h),
                              CustomButton.withIcon(
                                  AppColors.btnColor,
                                  intl.confirmContinue,
                                  Size(100.w, 6.h),
                                  Icon(Icons.arrow_forward),
                                  () {}),
                            ]));
                  else
                    return Center(
                        child: Container(
                            width: 15.w, height: 80.h, child: Progress()));
                })));
  }

  Widget bodyInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          bodyInformationParam(
              title: intl.weight,
              value: '100',
              unit: intl.kiloGr,
              valueColor: AppColors.bodyStateBlueColor,
              gradientColor: AppColors.bodyStateBlueColor),
          bodyInformationParam(
              title: intl.height,
              value: '160',
              unit: intl.centimeter,
              valueColor: AppColors.bodyStatePurpleColor,
              gradientColor: AppColors.bodyStatePurpleColor),
          bodyInformationParam(
              title: intl.birthday,
              value: '1378/05/22',
              unit: '',
              valueColor: AppColors.bodyStateOrangeColor,
              gradientColor: AppColors.bodyStateOrangeColor,
              fontSize: 12.sp),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          bodyInformationParam(
              title: intl.properWeight,
              value: '100',
              unit: intl.kiloGr,
              valueColor: AppColors.bodyStateGreenColor,
              gradientColor: AppColors.bodyStateGreenColor),
          bodyInformationParam(
              title: intl.extraWeight,
              value: '45',
              unit: intl.kiloGr,
              valueColor: AppColors.bodyStateRedColor,
              gradientColor: AppColors.bodyStateRedColor),
          bodyInformationParam(
              title: intl.necessaryTime,
              value: '40',
              unit: intl.day,
              valueColor: AppColors.bodyStateDarkBlueColor,
              gradientColor: AppColors.bodyStateDarkBlueColor),
        ])
      ],
    );
  }

  Widget bodyInformationParam(
      {required String title,
      required String value,
      required String unit,
      required Color valueColor,
      required Color gradientColor,
      double? fontSize}) {
    return Expanded(
      child: Container(
        height: 12.h,
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            stops: [.5, .5],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [
              gradientColor.withOpacity(0.05),
              Colors.transparent, // top Right part
            ],
          ),
          border: Border.all(color: gradientColor.withOpacity(0.08), width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                textDirection: context.textDirectionOfLocale,
                style: typography.caption!.copyWith(fontSize: 12.sp),
              ),
              Space(height: 1.h),
              RichText(
                textDirection: context.textDirectionOfLocale,
                text: TextSpan(
                  text: value,
                  style: typography.caption!.copyWith(
                      fontSize: fontSize ?? 14.sp,
                      fontWeight: FontWeight.w700,
                      color: valueColor),
                  children: <TextSpan>[
                    TextSpan(
                        text: unit,
                        style: typography.caption!
                            .copyWith(fontSize: 10.sp, color: valueColor))
                  ],
                ),
              )
            ]),
      ),
    );
  }

  Widget showWeightBmi(int? dietDays, String? weightDiff, String? weight,
      int? pregnancy, int? bmiStatus, String? bmi) {
    return Container(
      height: 30.h,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 40.w,
                        height: 23.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey.withOpacity(0.1),
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
                          height: 6.h,
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
        width: 40.w, height: 30.h, fit: BoxFit.fill);
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog)
      DialogUtils.showDialogProgress(context: context);
    regimeBloc.sendRequest();
  }

  @override
  void onRetryLoadingPage() {
    regimeBloc.physicalInfoData();
  }
}
