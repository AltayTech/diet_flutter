import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/diet/bloc.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/utility/ruler.dart';
import 'package:behandam/screens/utility/ruler_header.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class PhysicalInfoScreen extends StatefulWidget {
  const PhysicalInfoScreen({Key? key}) : super(key: key);

  @override
  _PhysicalInfoScreenState createState() => _PhysicalInfoScreenState();
}

class _PhysicalInfoScreenState extends ResourcefulState<PhysicalInfoScreen> {
  late PhysicalInfoBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = PhysicalInfoBloc();
    bloc.physicalInfo();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((next) {
      MemoryApp.page++;
      VxNavigator.of(context).push(Uri.parse('/$next'));
    });

    bloc.popLoadingDialog.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: Toolbar(
          titleBar: (navigator.currentConfiguration!.path.contains(Routes.weightEnter))
              ? intl.newVisit
              : intl.stateOfBody),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        width: 100.w,
        height: 100.h,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: TouchMouseScrollable(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 90.w,
                          child: Center(
                            child: StepperWidget(),
                          ),
                        ),
                        Text(
                          intl.enterYourState,
                          style: typography.subtitle2!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          intl.enterYourStateDescription,
                          style: typography.overline,
                        ),
                        Space(
                          height: 2.h,
                        ),
                        StreamBuilder<PhysicalInfoData>(
                            stream: bloc.physicalInfoData,
                            builder: (context, physicalInfo) {
                              if (physicalInfo.hasData)
                                return Column(
                                  children: [
                                    rulers(physicalInfo.requireData),
                                    Space(height: 2.h),
                                    birthDayBox(physicalInfo.requireData),
                                    Space(height: 2.h),
                                    genderBox(physicalInfo.requireData.gender ?? GenderType.Female),
                                    Space(
                                      height: 3.h,
                                    ),
                                  ],
                                );
                              else
                                return Center(child: Progress());
                            }),
                      ],
                    ),
                  ),
                )),
            Center(
              child: SubmitButton(
                label: intl.confirmContinue,
                onTap: () {
                  if (bloc.physicalInfoValue.weight == null ||
                      bloc.physicalInfoValue.height == null ||
                      bloc.physicalInfoValue.birthDate == null) {
                    Utils.getSnackbarMessage(context, intl.errorCompleteInfo);
                    return;
                  }
                  if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
                  bloc.sendRequest();
                },
              ),
            ),
            Space(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget rulers(PhysicalInfoData physicalInfo) {
    return Column(
      children: [
        Ruler(
          rulerType: RulerType.Weight,
          value: physicalInfo.weight != null ? '${physicalInfo.weight!.toStringAsFixed(3)}' : '0.0',
          max: 210,
          min: 30,
          heading: intl.weight,
          unit: intl.kilo,
          secondUnit: intl.gr,
          color: AppColors.purpleRuler,
          helpClick: () =>
              DialogUtils.showDialogPage(context: context, child: HelpDialog(helpId: 2)),
          iconPath: 'assets/images/diet/weight_icon.svg',
          onClick: (val) {
            physicalInfo.weight = double.parse('${val}');
          },
        ),
        Space(
          height: 1.h,
        ),
        Ruler(
          rulerType: RulerType.Normal,
          value: physicalInfo.height != null ? '${physicalInfo.height}' : '0',
          max: 300,
          min: 100,
          heading: intl.height,
          unit: intl.centimeter,
          color: AppColors.pinkRuler,
          helpClick: () =>
              DialogUtils.showDialogPage(context: context, child: HelpDialog(helpId: 3)),
          iconPath: 'assets/images/diet/height_icon.svg',
          onClick: (val) => physicalInfo.height = int.parse('${val}'),
        ),
      ],
    );
  }

  void setData(PhysicalInfoData data) {
    data.kilo = int.parse(data.weight!.toString().split('.').first);
    data.gram = int.parse(data.weight!.toString().split('.').last.substring(0, 1));
    data.isForbidden = false;
    data.mustGetNotrica = false;
    if (data.needToCall == null) data.needToCall = false;
    if (data.birthDate.isEmptyOrNull) data.isForbidden = true;
    // else {
    // if (DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays <
    //     (365 * 16)) {
    //   data.isForbidden = true;
    //   if (DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays >
    //       (365 * 10)) data.mustGetNotrica = true;
    // debugPrint(
    //     'date difference ${DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays}');
    // }
    // }
    if ((data.pregnancyWeek != null && data.pregnancyWeek! >= 35) ||
        (data.multiBirth != null && data.multiBirth! >= 2)) data.isForbidden = true;
  }

  Widget birthDayBox(PhysicalInfoData physicalInfo) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: RulerHeader(
            heading: intl.birthday,
          ),
        ),
        Space(height: 0.5.h),
        InkWell(
          child: ClipRRect(
            borderRadius: AppBorderRadius.borderRadiusDefault,
            child: Container(
              width: double.infinity,
              height: 7.h,
              color: AppColors.grey,
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      birthdateFormatted(physicalInfo) ?? '',
                      style: typography.subtitle2,
                    ),
                  ),
                  ImageUtils.fromLocal("assets/images/physical_report/date.svg",
                      width: 5.h, height: 5.h),
                ],
              ),
            ),
          ),
          onTap: () => _selectDate(physicalInfo),
        ),
        if (physicalInfo.birthDate.isEmptyOrNull)
          Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Text(
              intl.birthdateIsAMust,
              style: typography.caption?.apply(
                color: AppColors.primary,
              ),
            ),
          )
      ],
    );
  }

  String? birthdateFormatted(PhysicalInfoData physicalInfo) {
    if (!physicalInfo.birthDate.isEmptyOrNull) {
      var formatter = Jalali.fromDateTime(DateTime.parse(physicalInfo.birthDate!)).formatter;
      return '${formatter.d} ${formatter.mN} ${formatter.yyyy}';
    }
    return null;
  }

  void _selectDate(PhysicalInfoData physicalInfo) {
    DialogUtils.showBottomSheetPage(
        context: context,
        child: SingleChildScrollView(
          child: Container(
            height: 60.h,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.center,
            child: Column(
              children: [
                Row(
                  children: [
                    closeDialog(),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 4.h),
                          child: Center(
                            child: Text(
                              intl.selectPaymentDate,
                              softWrap: false,
                              style: typography.caption!
                                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ))
                  ],
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      intl.enterPaymentDate,
                      softWrap: false,
                      style: typography.caption!.copyWith(color: Colors.black, fontSize: 10.sp),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: CustomDate(
                      function: (value) {
                        bloc.date = value;
                      },
                      datetime:
                          DateTime.parse(Jalali.now().toDateTime().toString().substring(0, 10))
                              .toString()
                              .substring(0, 10),
                      maxYear: Jalali.now().year,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: SubmitButton(
                    label: intl.submitDate,
                    onTap: () {
                      if (bloc.date != null) {
                        setState(() {
                          physicalInfo.birthDate = bloc.date!;
                        });
                        Navigator.of(context).pop();
                      }
                    },
                    size: Size(80.w, 6.h),
                  )),
                )
              ],
            ),
          ),
        ));
  }

  Widget closeDialog() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topRight,
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

  Widget genderBox(GenderType gender) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 8.0),
          child: RulerHeader(
            heading: intl.gender,
          ),
        ),
        Space(height: 0.5.h),
        Row(
          children: [
            Expanded(
                child: CheckBoxApp.icon(
              isSelected: gender == GenderType.Female,
              onTap: () {
                bloc.setGender(GenderType.Female);
              },
              title: intl.womanItem,
              iconPath: 'assets/images/physical_report/female.svg',
              iconPathSelected: 'assets/images/physical_report/female_selected.svg',
            )),
            Space(
              width: 2.w,
            ),
            Expanded(
                child: CheckBoxApp.icon(
              isSelected: gender == GenderType.Male,
              onTap: () {
                bloc.setGender(GenderType.Male);
              },
              title: intl.menItem,
              iconPath: 'assets/images/physical_report/male.svg',
              iconPathSelected: 'assets/images/physical_report/male_selected.svg',
            )),
          ],
        ),
      ],
    );
  }

  @override
  void onRetryAfterNoInternet() {
    /*  if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    regimeBloc.sendRequest();*/
  }

  @override
  void onRetryLoadingPage() {
    // regimeBloc.physicalInfoData();
  }
}
