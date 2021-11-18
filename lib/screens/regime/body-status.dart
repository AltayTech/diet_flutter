import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';
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
    // TODO: implement initState
    super.initState();
    regimeBloc = RegimeBloc();
    listenBloc();
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(

        appBar:Toolbar(titleBar: intl.statusReport),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: StreamBuilder(
                stream: regimeBloc.status,
                builder: (context, AsyncSnapshot<BodyStatus> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        snapshot.data!.isPregnancy == 1
                            ? firstContainer(
                                snapshot.data!.dietDays,
                                snapshot.data!.pregnancyWeightDiff,
                                snapshot.data!.pregnancyWeight,
                                snapshot.data!.isPregnancy,
                                snapshot.data!.bmiStatus)
                            : firstContainer(
                                snapshot.data!.dietDays,
                                snapshot.data!.weightDifference,
                                snapshot.data!.normalWeight,
                                snapshot.data!.isPregnancy,
                                snapshot.data!.bmiStatus),
                        SizedBox(height: 2.h),
                        secondContainer(
                            snapshot.data!.bmi, snapshot.data!.bmiStatus),
                        snapshot.data!.isPregnancy == 1
                            ? ImageUtils.fromLocal(
                                'assets/images/physical_report/banner_pregnant.svg',
                                height: 15.h)
                            : ImageUtils.fromLocal(
                                'assets/images/physical_report/banner.svg',
                                height: 15.h),
                        button(AppColors.btnColor, intl.confirmContinue,
                            Size(100.w, 8.h), () {}),
                      ],
                    );
                  } else
                    return Center(
                        child: Container(
                            width: 15.w,
                            height: 15.w,
                            child: CircularProgressIndicator(
                                color: Colors.grey, strokeWidth: 1.0)));
                }),
          ),
        ),
      ),
    );
  }

  Widget firstContainer(int? dietDays, var weightDiff, var weight, int? pregnancy, int? bmiStatus) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Column(
          children: [
            Row(
              children: [
                pregnancy == 1
                    ? ImageUtils.fromLocal( 'assets/images/physical_report/element1.svg')
                    : Container(),
                pregnancy == 1
                    ? ImageUtils.fromLocal( 'assets/images/physical_report/element2.svg')
                    : Container(),
                Text(intl.firstStatusReport, textAlign: TextAlign.center),
                pregnancy == 1
                    ? ImageUtils.fromLocal( 'assets/images/physical_report/element3.svg')
                    : Container(),
                pregnancy == 1
                    ? ImageUtils.fromLocal( 'assets/images/physical_report/element4.svg')
                    : Container(),
              ],
            ),
            SizedBox(height: 5.h),
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
                      ? colorfulContainer('$dietDays', intl.day, intl.untilBeingMom,
                          intl.appropriateWeight,AppColors.pregnantPink)
                      : colorfulContainer('$dietDays', intl.day, intl.untilReach,
                          intl.appropriateWeight,AppColors.purpleRuler),
                      SizedBox(height: 2.h),
                      bmiStatus == 0 && pregnancy != 1
                      ? colorfulContainer(
                          '$weightDiff', intl.kilo, intl.lakeWeight, '',AppColors.purpleRuler)
                      : colorfulContainer(
                          '$weightDiff', intl.kilo, intl.extraWeight, '',AppColors.purpleRuler),
                      if(pregnancy == 1)
                        colorfulContainer(
                            '$weightDiff', intl.kilo, intl.getWeight, '',AppColors.pregnantPink),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
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
                          ? Text(intl.appropriateWeightPregnancy)
                          : Text(intl.yourAppropriateWeight),
                          Container(
                            width: 30.w,
                            height: 9.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            child: Center(
                                child: Column(
                              children: [
                                Text('$weight',
                                    style: TextStyle(
                                        color: AppColors.purpleRuler)),
                                Text(intl.kiloGr,
                                    style:
                                        TextStyle(color: AppColors.purpleRuler))
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
                              onTap: () => DialogUtils.showBottomSheetPage(context: context, child: help(5)),
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
        ),
      ),
    );
  }

  Widget colorfulContainer(
      String txt1,
      String txt2,
      String txt3,
      String txt4,
      Color color
  ) {
    return Container(
        width: 30.w,
        height: 9.h,
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
              height: 9.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                  color: color)),
          SizedBox(width: 4.w),
          Container(
            width: 20.w,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: txt1,
                      style: TextStyle(
                          fontSize: 14.sp, color: color),
                      children: <TextSpan>[
                        TextSpan(text: txt2, style: TextStyle(fontSize: 12.0))
                      ],
                    ),
                  ),
                  Text(txt3, style: TextStyle(fontSize: 12.0)),
                  Text(txt4, style: TextStyle(fontSize: 12.0))
                ],
              ),
            ),
          )
        ]));
  }

  Widget secondContainer(var bmi, int? bmiStatus) {
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.only(right: 12, left: 12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 39.w,
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
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.white),
                            child: Center(child: Text('$bmi')),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: AppColors.redBar)),
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        child: InkWell(
                          onTap: () => DialogUtils.showBottomSheetPage(context: context, child: help(1)),
                          child: Row(
                            children: [
                              ImageUtils.fromLocal(
                                  'assets/images/physical_report/bmi.svg',
                                  width: 2.w,
                                  height: 2.h),
                              SizedBox(width: 2.w),
                              Text('BMI',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: AppColors.redBar)),
                              SizedBox(width: 1.w),
                              Text(intl.what,
                                  style: TextStyle(
                                      fontSize: 14.sp, color: AppColors.redBar)),
                              ImageUtils.fromLocal(
                                  'assets/images/physical_report/guide.svg',
                                  width: 3.w,
                                  height: 3.h),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(width: 2.w),
                bmiPic(bmiStatus),
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
          height: 30.h,
        );
      case 2:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/fat.svg',
          width: 40.w,
          height: 30.h,
        );
      case 3:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/obesity.svg',
          width: 40.w,
          height: 30.h,
        );
      case 4:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 30.h,
        );
      case 5:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 30.h,
        );
      default:
        return ImageUtils.fromLocal(
          'assets/images/physical_report/extreme_obesity.svg',
          width: 40.w,
          height: 30.h,
        );
    }
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

@override
void onRetryLoadingPage() {
  // TODO: implement onRetryLoadingPage
}
