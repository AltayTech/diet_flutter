import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/regime/ruler_header.dart';
import 'package:behandam/screens/utility/custom_ruler.dart';
import 'package:behandam/screens/utility/alert.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  PhysicalInfoData? body;
  int? height;
  String label = '';
  String? date;
  late RegimeType regime;
  bool isForbidden = false;

  @override
  void initState() {
    super.initState();
    regimeBloc = RegimeBloc();
    regimeBloc.physicalInfoData();
    body = PhysicalInfoData();
    body!.weight = 70.5003432;
    body!.kilo = int.parse(body!.weight!.toString().split('.').first);
    body!.gram =
        int.parse(body!.weight!.toString().split('.').last.substring(0, 1));
    debugPrint('kilo ${body!.weight} ${body!.kilo} / ${body!.gram}');
    body!.height = 170;
    body!.wrist = 15;
    body!.pregnancyWeek = 15;
    body!.multiBirth = 1;
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.navigateToVerify.listen((event) {
      if ((event as bool)) {
        VxNavigator.of(context).push(
          Uri.parse(Routes.pass),
        );
      }
    });
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    regime = ModalRoute.of(context)!.settings.arguments as RegimeType;
    print('physical arg ${regime.toJson()}');
    return Scaffold(
      appBar: Toolbar(titleBar: intl.stateOfBody),
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
                Text(
                  intl.enterYourState,
                  textAlign: TextAlign.center,
                  style: typography.subtitle2,
                ),
                StreamBuilder(
                    stream: regimeBloc.physicalInfo,
                    builder: (_, AsyncSnapshot<PhysicalInfoData> snapshot){
                      if(snapshot.hasData){
                        setData(snapshot.requireData);
                        return Column(
                          children: [
                            rulers(),
                            birthDayBox(),
                          ],
                        );
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                ),
                // rulers(),
                // birthDayBox(),
                Space(height: 2.h),
                if (isForbidden)
                  Alert(text: intl.itIsNotPossible)
                else
                  button(
                    AppColors.btnColor,
                    intl.confirmContinue,
                    Size(100.w, 8.h),
                    () => regimeBloc.sendInfo(body!),
                  ),
                Space(height: 2.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget rulers() {
    return Column(
      children: [
        CustomRuler(
          rulerType: RulerType.Weight,
          value: body!.kilo!,
          secondValue: body!.gram,
          max: 210,
          min: 30,
          heading: intl.weight,
          unit: intl.kilo,
          secondUnit: intl.gr,
          color: AppColors.purpleRuler,
          helpClick: () =>
              DialogUtils.showBottomSheetPage(
                  context: context, child: help(2)),
          iconPath: 'assets/images/diet/weight_icon.svg',
          onClick: (val) => setState(() => body!.kilo = val),
          onClickSecond: (val) => setState(() => body!.gram = val),
        ),
        CustomRuler(
          rulerType: RulerType.Normal,
          value: body!.height!,
          max: 210,
          min: 50,
          heading: intl.height,
          unit: intl.centimeter,
          color: AppColors.pinkRuler,
          helpClick: () =>
              DialogUtils.showBottomSheetPage(
                  context: context, child: help(3)),
          iconPath: 'assets/images/diet/height_icon.svg',
          onClick: (val) => setState(() => body!.height = val),
        ),
        CustomRuler(
          rulerType: RulerType.Normal,
          value: body!.wrist!,
          max: 40,
          min: 10,
          heading: intl.wrist,
          unit: intl.centimeter,
          color: AppColors.blueRuler,
          helpClick: () =>
              DialogUtils.showBottomSheetPage(
                  context: context, child: help(4)),
          iconPath: 'assets/images/diet/wrist_icon.svg',
          onClick: (val) => setState(() => body!.wrist = val),
        ),
        if (regime.alias == RegimeAlias.Pregnansy)
          CustomRuler(
            rulerType: RulerType.Pregnancy,
            value: body!.pregnancyWeek!,
            secondValue: body!.multiBirth!,
            max: 42,
            min: 1,
            heading: intl.pregnancyWeek,
            unit: intl.week,
            // secondUnit: '',
            color: AppColors.greenRuler,
            helpClick: () =>
                DialogUtils.showBottomSheetPage(
                    context: context, child: help(6)),
            iconPath: 'assets/images/diet/pregnancy_icon.svg',
            onClick: (val) =>
                setState(() {
                  body!.pregnancyWeek = val;
                  if (body!.pregnancyWeek! >= 35)
                    isForbidden = true;
                  else
                    isForbidden = false;
                }),
            onClickSecond: (val) =>
                setState(() {
                  body!.multiBirth = val;
                  if (body!.multiBirth! >= 2)
                    isForbidden = true;
                  else
                    isForbidden = false;
                }),
          ),
      ],
    );
  }

  void setData(PhysicalInfoData data){
    body!.kilo = int.parse(data.weight!
        .toString()
        .split('.')
        .first);
    body!.gram =
        int.parse(data.weight!
            .toString()
            .split('.')
            .last
            .substring(0, 1));
    body!.weight = data.weight;
    body!.height = data.height;
    body!.wrist = data.wrist;
    body!.birthDate = data.birthDate;
    body!.multiBirth = data.multiBirth;
    body!.pregnancyWeek = data.pregnancyWeek;
  }

  Widget birthDayBox() {
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
                    birthdateFormatted() ?? '',
                    style: typography.subtitle2,
                  ),
                ],
              ),
            ),
          ),
          onTap: _selectDate,
        ),
        if (body!.birthDate.isEmptyOrNull)
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

  String? birthdateFormatted() {
    if (!body!.birthDate.isEmptyOrNull) {
      var formatter =
          Jalali.fromDateTime(DateTime.parse(body!.birthDate!)).formatter;
      return '${formatter.d} ${formatter.mN} ${formatter.yyyy}';
    }
    return null;
  }

  Future _selectDate() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1200, 8),
      lastDate: Jalali(1450, 9),
    );
    setState(() {
      date = picked!.toGregorian().toDateTime().toString().substring(0, 10);
      body!.birthDate = date;
      debugPrint('birthdate $date / $picked');
    });
  }

  Widget help(int id) {
    regimeBloc.helpBodyState(id);
    return StreamBuilder(
        stream: regimeBloc.helpers,
        builder: (context, AsyncSnapshot<List<Help>> snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(regimeBloc.name),
                      SizedBox(height: 2.h),
                      id == 2
                          ? ImageUtils.fromLocal(
                              'assets/images/diet/body-scale-happy.svg',
                              width: 20.w,
                              height: 20.h,
                            )
                          : Container(),
                      SizedBox(height: 2.h),
                      Text(snapshot.data![0].body!,
                          style: TextStyle(fontSize: 16.0)),
                      SizedBox(height: 2.h),
                      button(AppColors.btnColor, intl.understand,
                          Size(100.w, 8.h), () => Navigator.of(context).pop())
                    ],
                  ),
                ),
              ),
            );
          } else
            return Center(
                child: Container(
                    width: 15.w,
                    height: 15.w,
                    child: CircularProgressIndicator(
                        color: Colors.grey, strokeWidth: 1.0)));
        });
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
}
