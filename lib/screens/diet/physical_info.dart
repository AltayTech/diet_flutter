import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/screens/diet/bloc.dart';
import 'package:behandam/screens/regime/ruler_header.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/utility/ruler.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class PhysicalInfoScreen extends StatefulWidget {
  const PhysicalInfoScreen({Key? key}) : super(key: key);

  @override
  _PhysicalInfoScreenState createState() => _PhysicalInfoScreenState();
}

class _PhysicalInfoScreenState extends ResourcefulState<PhysicalInfoScreen> {
  late PhysicalInfoBloc bloc;
  late ProgressTimeline _progressTimeline;

  @override
  void initState() {
    super.initState();
    _progressTimeline = ProgressTimeline(
      states: [
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
      ],
      height: 6.8.h,
      width: 50.w,
      checkedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 5.w, height: 5.w, fit: BoxFit.fill),
      currentIcon: ImageUtils.fromLocal("assets/images/physical_report/current_step.svg",
          width: 5.w, height: 5.w, fit: BoxFit.fill),
      failedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 5.w, height: 5.w, fit: BoxFit.fill),
      uncheckedIcon: ImageUtils.fromLocal("assets/images/physical_report/none_step.svg",
          width: 5.w, height: 5.w, fit: BoxFit.fill),
      iconSize: 5.w,
      connectorLength: 10.w,
      connectorColorSelected: AppColors.primary,
      connectorWidth: 1.5.w,
      connectorColor: Colors.grey,
    );

    bloc = PhysicalInfoBloc();
    bloc.physicalInfo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(
          titleBar: (navigator.currentConfiguration!.path.contains(Routes.weightEnter))
              ? intl.newVisit
              : intl.stateOfBody),
      body: SingleChildScrollView(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          shape: AppShapes.rectangleMild,
          elevation: 2,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 90.w,
                  child: Center(
                    child: _progressTimeline,
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
                            Row(
                              children: [
                                Expanded(child: genderItem(true, GenderType.Male)),
                                Expanded(child: genderItem(false, GenderType.Female)),
                              ],
                            ),
                            Space(
                              height: 1.h,
                            ),
                            SubmitButton(
                              label: intl.confirmContinue,
                              onTap: () {
                                _progressTimeline.gotoNextStage();
                              },
                            ),
                            Space(height: 2.h),
                          ],
                        );
                      else
                        return Center(child: Progress());
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rulers(PhysicalInfoData physicalInfo) {
    return Column(
      children: [
        Ruler(
          rulerType: RulerType.Weight,
          value: '${physicalInfo.weight}',
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
          value: '${physicalInfo.height}',
          max: 210,
          min: 50,
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
        RulerHeader(
          iconPath: 'assets/images/diet/birth_icon.svg',
          heading: intl.birthday,
        ),
        Space(height: 1.5.h),
        InkWell(
          child: ClipRRect(
            borderRadius: AppBorderRadius.borderRadiusDefault,
            child: Container(
              width: double.infinity,
              height: 7.h,
              color: AppColors.grey,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 12.w,
                    height: double.infinity,
                    color: AppColors.strongPen,
                    child: Icon(
                      Icons.calendar_today,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    birthdateFormatted(physicalInfo) ?? '',
                    style: typography.subtitle2,
                  ),
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

  Future _selectDate(PhysicalInfoData physicalInfo) async {
    DialogUtils.showBottomSheetPage(
        context: context,
        child: SingleChildScrollView(
          child: Container(
            height: 32.h,
            padding: EdgeInsets.all(5.w),
            alignment: Alignment.center,
            child: Center(
              child: CustomDate(
                function: (value) {
                  print('value = > $value');
                  setState(() {
                    physicalInfo.birthDate = value!;
                  });
                },
                datetime: physicalInfo.birthDate,
                maxYear: Jalali.now().year - 10,
              ),
            ),
          ),
        ));
  }

  Widget genderItem(bool isSelected, GenderType type) {
    return InkWell(
      onTap: () {},
      child: Container(
        width: double.maxFinite,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          border:
              isSelected ? Border.all(color: AppColors.priceColor) : Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10),
        ),
        constraints: BoxConstraints(minHeight: 8.h),
        child: Container(
          margin: EdgeInsets.only(right: 2.w),
          width: double.maxFinite,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: ImageUtils.fromLocal(
                  isSelected ? 'assets/images/bill/check.svg' : 'assets/images/bill/not_select.svg',
                  width: 3.w,
                  height: 3.h,
                ),
              ),
              Space(
                width: 1.w,
              ),
              Expanded(
                flex: 1,
                child: ImageUtils.fromLocal(
                    type == GenderType.Male
                        ? 'assets/images/physical_report/male.svg'
                        : 'assets/images/physical_report/female.svg',
                    width: 3.w,
                    height: 3.h,
                    color: isSelected
                        ? AppColors.greenRuler
                        : AppColors.labelTextColor),
              ),
              Space(
                width: 1.w,
              ),
              Expanded(
                flex: 2,
                child: Container(
                  width: double.maxFinite,
                  child: Text(
                    type == GenderType.Male ? intl.manItem : intl.womanItem,
                    softWrap: false,
                    textAlign: TextAlign.start,
                    style: typography.caption!.copyWith(
                        color: isSelected ? AppColors.priceColor : Colors.black, fontSize: 10.sp),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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
