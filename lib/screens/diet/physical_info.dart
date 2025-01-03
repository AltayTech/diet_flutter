import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/double.dart';
import 'package:behandam/screens/diet/bloc.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/utility/ruler.dart';
import 'package:behandam/screens/utility/ruler_header.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class PhysicalInfoScreen extends StatefulWidget {
  const PhysicalInfoScreen({Key? key}) : super(key: key);

  @override
  _PhysicalInfoScreenState createState() => _PhysicalInfoScreenState();
}

class _PhysicalInfoScreenState extends ResourcefulState<PhysicalInfoScreen> {
  late PhysicalInfoBloc bloc;
  bool isInit = false;
  bool isShowStepper = true;
  int maxYear = 1391;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      isShowStepper = ModalRoute.of(context)!.settings.arguments as bool;
      bloc = PhysicalInfoBloc();
      bloc.physicalInfo();
      initDatePicker();
      listenBloc();
    }
  }

  void listenBloc() {
    bloc.navigateTo.listen((next) {
      if (isShowStepper) {
        MemoryApp.page++;
        VxNavigator.of(context).push(Uri.parse('/$next'));
      } else {
        VxNavigator.of(context).returnAndPush(true);
      }
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
      appBar: Toolbar(titleBar: intl.stateOfBody),
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
                        if (isShowStepper)
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
                                    if (!navigator.currentConfiguration!.path.contains('renew'))
                                      Column(
                                        children: [
                                          Space(height: 2.h),
                                          birthDayBox(physicalInfo.requireData),
                                          Space(height: 2.h),
                                          genderBox(
                                              physicalInfo.requireData.gender ?? GenderType.Female),
                                        ],
                                      ),
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
                child: CustomButton.withIcon(
                    AppColors.btnColor, intl.nextStage, Size(100.w, 6.h), Icon(Icons.arrow_forward),
                    () {
              if ((bloc.physicalInfoValue.weight == null ||
                      bloc.physicalInfoValue.height == null) ||
                  (bloc.physicalInfoValue.birthDate == null &&
                      !navigator.currentConfiguration!.path.contains('renew'))) {
                Utils.getSnackbarMessage(context, intl.errorCompleteInfo);
                return;
              }
              if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
              if (navigator.currentConfiguration!.path.contains('renew'))
                bloc.physicalInfoValue.gender = null;
              bloc.sendRequest();
            })),
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
          value: physicalInfo.weight != null
              ? '${physicalInfo.weight!.toStringAsFixedWithOneZero(3)}'
              : '0.0',
          max: 210,
          min: 30,
          heading: intl.weight,
          unit: intl.kilo,
          secondUnit: intl.gr,
          color: AppColors.purpleRuler,
          helpClick: () =>
              DialogUtils.showBottomSheetPage(context: context, child: HelpDialog(helpId: 2)),
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
          color: AppColors.blueRuler,
          helpClick: () =>
              DialogUtils.showBottomSheetPage(context: context, child: HelpDialog(helpId: 3)),
          iconPath: 'assets/images/diet/height_icon.svg',
          onClick: (val) => physicalInfo.height = int.parse('${val}'),
        ),
      ],
    );
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
            borderRadius: BorderRadius.circular(10),
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
            height: 55.h,
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
                              intl.birthday,
                              softWrap: false,
                              style: typography.caption!
                                  .copyWith(color: Colors.black, fontWeight: FontWeight.w700),
                            ),
                          ),
                        ))
                  ],
                ),
                Space(
                  height: 3.h,
                ),
                Expanded(
                  flex: 3,
                  child: Center(
                    child: CustomDate(
                      function: (value) {
                        bloc.date = value;
                      },
                      datetime: bloc.date,
                      maxYear: maxYear,
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                      child: CustomButton(
                    AppColors.btnColor,
                    intl.ok,
                    Size(80.w, 6.h),
                    () {
                      if (bloc.date != null) {
                        setState(() {
                          physicalInfo.birthDate = bloc.date!;
                        });
                        Navigator.of(context).pop();
                      }
                    },
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
              maxHeight: 10.h,
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
              maxHeight: 10.h,
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

  void initDatePicker() {
    Jalali jalali = Jalali.now();
    Jalali j = Jalali(jalali.year - 10, jalali.month, jalali.day);

    maxYear = j.year;

    bloc.date = j.toDateTime().toString().substring(0, 10);
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryAfterNoInternet();
  }

  @override
  void onRetryLoadingPage() {

    bloc.onRetryLoadingPage();
  }
}
