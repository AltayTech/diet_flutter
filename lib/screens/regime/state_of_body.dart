import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/body_state.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/utility/CustomRuler.dart';
import 'package:behandam/screens/utility/alert.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
  BodyState? body;
  int?  height;
  String label = '';
  String? date;
  var arg;
  bool disable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    body = BodyState();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.navigateToVerify.listen((event) {
      // try {
      if ((event as bool)) {
        VxNavigator.of(context).push(Uri.parse(Routes.pass),);
      }
      // }catch(e){
      //   print('e ==> ${e.toString()}');
      // }
    });
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  Future _selectDate() async {
    Jalali? picked = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1385, 8),
      lastDate: Jalali(1450, 9),
    );
    // if (picked != null) setState(() => _value = picked);
    setState(() {
      date = picked!.toGregorian().toDateTime().toString().substring(0,11);
      label = picked.formatCompactDate();
      int dis = int.parse(date!.substring(0,4)) - Jalali.now().toGregorian().year;
      if(dis < 10)
       setState(() {
         disable = true;
       });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    arg = ModalRoute.of(context)!.settings.arguments;
    print(arg);
    return Scaffold(
      appBar:Toolbar(titleBar: intl.stateOfBody),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30.0,bottom: 20.0),
                  child: Text(intl.enterYourState,textAlign: TextAlign.center,),
                ),
              CustomRuler(
                rulerType: RulerType.Weight,
                value: body!.weight != null ? body!.weight : 70,
                max: 210,
                min: 30,
                heading: intl.weight,
                unit: intl.kilo,
                color: AppColors.purpleRuler,
                helpClick: () => DialogUtils.showBottomSheetPage(context: context, child: help(2)),
                iconPath: 'assets/images/diet/weight_icon.svg',
                onClick: (val) =>
                    setState(() => body!.weight = val),
              ),
              SizedBox(height: 5.h),
              CustomRuler(
                rulerType: RulerType.Normal,
                value: body!.height != null ? body!.height : 170,
                max: 210,
                min: 50,
                heading: intl.height,
                unit: intl.centimeter,
                color: AppColors.pinkRuler,
                helpClick: () => DialogUtils.showBottomSheetPage(context: context, child: help(3)),
                iconPath: 'assets/images/diet/height_icon.svg',
                onClick: (val) =>
                    setState(() => body!.height = val),
              ),
              SizedBox(height: 5.h),
              CustomRuler(
                rulerType: RulerType.Normal,
                value: body!.wrist != null ? body!.wrist : 20,
                max: 40,
                min: 10,
                heading: intl.wrist,
                unit: intl.centimeter,
                color: AppColors.blueRuler,
                helpClick: () => DialogUtils.showBottomSheetPage(context: context, child: help(4)),
                iconPath: 'assets/images/diet/wrist_icon.svg',
                onClick: (val) =>
                    setState(() => body!.wrist = val),
              ),
                SizedBox(height: 5.h),
                // arg == 5 //pregnancy type
                // ?
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: CustomRuler(
                        rulerType: RulerType.Pregnancy,
                        value: body!.pregnancyWeek != null ? body!.pregnancyWeek : 15,
                        max: 42,
                        min: 1,
                        heading: intl.pregnancyWeek,
                        unit: intl.week,
                        color: AppColors.greenRuler,
                        helpClick: () => DialogUtils.showBottomSheetPage(context: context, child: help(6)),
                        iconPath: 'assets/images/diet/pregnancy_icon.svg',
                        onClick: (val) =>
                            setState(() => body!.pregnancyWeek = val),
                        hideBtn: (val) => setState(() => disable = val),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: CustomRuler(
                        rulerType: RulerType.Twin,
                        value: body!.multiBirth != null ? body!.multiBirth : 1,
                        max: 16,
                        min: 1,
                        heading: intl.multiBirth,
                        unit: intl.multi,
                        color: AppColors.greenRuler,
                        helpClick: () => {},
                        iconPath: '',
                        onClick: (val) =>
                            setState(() => body!.multiBirth = val),
                        hideBtn: (val) => setState(() => disable = val),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5.h),
                // : Container(),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0, left: 12.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              ImageUtils.fromLocal('assets/images/diet/birth_icon.svg',
                                  width: 6.w,
                                  height: 6.h),
                              Padding(
                                padding: const EdgeInsets.only(right: 12.0),
                                child: Text(intl.birthday),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      InkWell(
                        child: Container(
                          width: double.infinity,
                          height: (240 / 100) * 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: AppColors.grey,
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 12.w,
                                height: (240 / 100) * 25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(20),
                                      bottomRight: Radius.circular(20)),
                                  color: AppColors.strongPen,
                                ),
                                child: Icon(Icons.calendar_today,
                                color: Colors.white,),
                              ),
                              SizedBox(width: 2.w),
                              Text(label.isEmpty ? ' ' : label.toString(),
                              style: TextStyle(fontSize: 12),)
                            ],
                          ),
                        ),
                        onTap: _selectDate,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                if(disable)
                 alert(intl.itIsNotPossible)
                else
                 button(AppColors.btnColor, intl.confirmContinue,Size(100.w,8.h),
                        (){
                          BodyState info = BodyState();
                          info.height = body!.height;
                          info.weight = body!.weight;
                          info.wrist = body!.wrist;
                          info.birthDate = date;
                          regimeBloc.sendInfo(info);
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget help(int id){
    regimeBloc.helpBodyState(id);
    return  StreamBuilder(
        stream: regimeBloc.helpers,
        builder: (context, AsyncSnapshot<List<Help>> snapshot){
                if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.0),
                        color:Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(regimeBloc.name),
                            SizedBox(height: 2.h),
                            id == 2
                            ? ImageUtils.fromLocal('assets/images/diet/body-scale-happy.svg',width: 20.w,height: 20.h,)
                            : Container(),
                            SizedBox(height: 2.h),
                            Text(snapshot.data![0].body!,style: TextStyle(fontSize: 16.0)),
                            SizedBox(height: 2.h),
                            button(AppColors.btnColor, intl.understand,Size(100.w,8.h),
                                    () => Navigator.of(context).pop())
                          ],
                        ),
                      ),
                    ),
                  );
                }
                else
                  return Center(
                      child: Container(
                          width:15.w,
                          height: 15.w,
                          child: CircularProgressIndicator(color: Colors.grey,strokeWidth: 1.0)));

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
