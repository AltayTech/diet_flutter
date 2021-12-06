import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/screens/regime/provider.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/regime/ruler_header.dart';
import 'package:behandam/screens/utility/alert.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/widget/custom_date_picker.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class BodyStateScreen extends StatefulWidget {
  const BodyStateScreen({Key? key}) : super(key: key);

  @override
  _BodyStateScreenState createState() => _BodyStateScreenState();
}

class _BodyStateScreenState extends ResourcefulState<BodyStateScreen> {
  late RegimeBloc regimeBloc;

  @override
  void initState() {
    super.initState();
    regimeBloc = RegimeBloc();
    regimeBloc.physicalInfoData();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.navigateToVerify.listen((event) {
      Navigator.of(context).pop();
      VxNavigator.of(context).push(
        Uri.parse('/$event'),
      );
    });
    regimeBloc.showServerError.listen((event) {
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

    return RegimeProvider(
      regimeBloc,
      child: Scaffold(
        appBar: Toolbar(
            titleBar: (navigator.currentConfiguration!.path == Routes.weightEnter ||
                    navigator.currentConfiguration!.path == Routes.renewWeightEnter)
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (navigator.currentConfiguration!.path != Routes.weightEnter &&
                      navigator.currentConfiguration!.path != Routes.renewWeightEnter)
                    Text(
                      intl.enterYourState,
                      textAlign: TextAlign.center,
                      style: typography.subtitle2,
                    ),
                  StreamBuilder(
                    stream: regimeBloc.physicalInfo,
                    builder: (_, AsyncSnapshot<PhysicalInfoData> snapshot) {
                      if (snapshot.hasData) {
                        setData(snapshot.requireData);
                        return Column(
                          children: [
                            rulers(snapshot.requireData),
                            if (navigator.currentConfiguration!.path != Routes.weightEnter &&
                                navigator.currentConfiguration!.path != Routes.renewWeightEnter)
                              birthDayBox(snapshot.requireData),
                            Space(height: 2.h),
                            if (!snapshot.requireData.isForbidden.isNullOrFalse)
                              Alert(
                                  text: snapshot.requireData.mustGetNotrica.isNullOrFalse
                                      ? intl.itIsNotPossible
                                      : intl.userNotricaRegime)
                            else
                              button(
                                AppColors.btnColor,
                                intl.confirmContinue,
                                Size(100.w, 8.h),
                                () {
                                  DialogUtils.showDialogProgress(context: context);
                                  snapshot.requireData.weight = double.parse(
                                      '${snapshot.requireData.kilo}.${snapshot.requireData.gram}');
                                  debugPrint('body weight ${snapshot.requireData.weight}');
                                  if (navigator.currentConfiguration!.path == Routes.weightEnter)
                                    regimeBloc.sendVisit(snapshot.requireData);
                                  else if (navigator.currentConfiguration!.path ==
                                      Routes.renewWeightEnter)
                                    regimeBloc.sendWeight(snapshot.requireData);
                                  else
                                    regimeBloc.sendInfo(snapshot.requireData);
                                },
                              ),
                            Space(height: 2.h),
                          ],
                        );
                      }
                      return Center(child: Progress());
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget rulers(PhysicalInfoData physicalInfo) {
    return Column(
      children: [
        CustomRuler(
          rulerType: RulerType.Weight,
          value: physicalInfo.kilo!,
          secondValue: physicalInfo.gram!,
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
            physicalInfo.kilo = val;
            physicalInfo.weight = double.parse('${physicalInfo.kilo}.${physicalInfo.gram}');
          },
          onClickSecond: (val) {
            physicalInfo.gram = val;
            physicalInfo.weight = double.parse('${physicalInfo.kilo}.${physicalInfo.gram}');
          },
        ),
        if (navigator.currentConfiguration!.path != Routes.weightEnter &&
            navigator.currentConfiguration!.path != Routes.renewWeightEnter)
          CustomRuler(
            rulerType: RulerType.Normal,
            value: physicalInfo.height!,
            max: 210,
            min: 50,
            heading: intl.height,
            unit: intl.centimeter,
            color: AppColors.pinkRuler,
            helpClick: () =>
                DialogUtils.showDialogPage(context: context, child: HelpDialog(helpId: 3)),
            iconPath: 'assets/images/diet/height_icon.svg',
            onClick: (val) => physicalInfo.height = val,
          ),
        if (navigator.currentConfiguration!.path != Routes.weightEnter &&
            navigator.currentConfiguration!.path != Routes.renewWeightEnter)
          CustomRuler(
            rulerType: RulerType.Normal,
            value: physicalInfo.wrist!,
            max: 40,
            min: 10,
            heading: intl.wrist,
            unit: intl.centimeter,
            color: AppColors.blueRuler,
            helpClick: () =>
                DialogUtils.showDialogPage(context: context, child: HelpDialog(helpId: 4)),
            iconPath: 'assets/images/diet/wrist_icon.svg',
            onClick: (val) => physicalInfo.wrist = val,
          ),
        if (physicalInfo.dietTypeAlias == RegimeAlias.Pregnancy)
          CustomRuler(
            rulerType: RulerType.Pregnancy,
            value: physicalInfo.pregnancyWeek!,
            secondValue: physicalInfo.multiBirth!,
            max: 42,
            min: 1,
            heading: intl.pregnancyWeek,
            unit: intl.week,
            color: AppColors.greenRuler,
            helpClick: () =>
                DialogUtils.showDialogPage(context: context, child: HelpDialog(helpId: 6)),
            iconPath: 'assets/images/diet/pregnancy_icon.svg',
            onClick: (val) => setState(() {
              physicalInfo.pregnancyWeek = val;
              if (physicalInfo.pregnancyWeek! >= 35)
                physicalInfo.isForbidden = true;
              else
                physicalInfo.isForbidden = false;
            }),
            onClickSecond: (val) => setState(() {
              physicalInfo.multiBirth = val;
              if (physicalInfo.multiBirth! >= 2)
                physicalInfo.isForbidden = true;
              else
                physicalInfo.isForbidden = false;
            }),
          ),
      ],
    );
  }

  void setData(PhysicalInfoData data) {
    data.kilo = int.parse(data.weight!.toString().split('.').first);
    data.gram = int.parse(data.weight!.toString().split('.').last.substring(0, 1));
    data.isForbidden = false;
    data.mustGetNotrica = false;
    if (data.birthDate.isEmptyOrNull)
      data.isForbidden = true;
    else {
      if (DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays < (365 * 16)) {
        data.isForbidden = true;
        if (DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays > (365 * 10))
          data.mustGetNotrica = true;
        debugPrint(
            'date difference ${DateTime.now().difference(DateTime.parse(data.birthDate!)).inDays}');
      }
    }
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
