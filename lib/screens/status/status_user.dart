import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/screens/status/bloc.dart';
import 'package:behandam/screens/status/chart_weight.dart';
import 'package:behandam/screens/status/status_provider.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class StatusUserScreen extends StatefulWidget {
  const StatusUserScreen({Key? key}) : super(key: key);

  @override
  _StatusUserScreenState createState() => _StatusUserScreenState();
}

class _StatusUserScreenState extends ResourcefulState<StatusUserScreen> {
  late StatusBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = StatusBloc();
    bloc.getVisitUser();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return StatusProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: intl.statusBodyTermUser),
        body: body(),
      ),
    );
  }

  Widget body() {
    return Container(
      width: 100.w,
      height: 100.h,
      child: Stack(
        children: [
          content(),
          Positioned(
            bottom: 0,
            child: BottomNav(
              currentTab: BottomNavItem.STATUS,
            ),
          )
        ],
      ),
    );
  }

  Widget content() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: StreamBuilder(
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false) {
              return Padding(
                padding: EdgeInsets.all(2.w),
                child: Container(
                  constraints:
                      BoxConstraints(minHeight: 110.h, minWidth: 100.w),
                  color: Color.fromRGBO(245, 245, 245, 1),
                  padding: EdgeInsets.fromLTRB(
                    4.w,
                    3.h,
                    4.w,
                    6.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    textDirection: context.textDirectionOfLocale,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.all(4.w),
                        child: Column(
                          children: [
                            itemUi('', getDietTypeString(), intl.dietType),
                            Space(height: 1.h),
                            itemUi(
                                intl.old,
                                (bloc.visitItem?.physicalInfo?.age.toString() ??
                                    intl.none),
                                intl.age),
                            Space(height: 1.h),
                            itemUi(
                                intl.centimeter,
                                bloc.visitItem?.physicalInfo?.height
                                        .toString() ??
                                    intl.none,
                                intl.height),
                            Space(height: 1.h),
                            itemUi(
                                intl.kiloGr,
                                bloc.activeTerms?.firstWeight
                                        ?.toStringAsFixed(1) ??
                                    intl.none,
                                intl.firstWeight),
                            Space(height: 1.h),
                            itemUi(
                                intl.kiloGr,
                                bloc.activeTerms?.lostWeight
                                        ?.abs()
                                        .toStringAsFixed(1) ??
                                    intl.none,
                                (bloc.activeTerms != null &&
                                        bloc.activeTerms!.lostWeight! > 0)
                                    ? intl.addedWeight
                                    : (bloc.activeTerms != null &&
                                            bloc.activeTerms!.lostWeight! == 0)
                                        ? intl.noChangeWeight
                                        : intl.lostWeight),
                            Space(height: 1.h),
                            itemUi(
                                intl.kiloGr,
                                bloc.visitItem?.weightDifference
                                        ?.abs()
                                        .toStringAsFixed(1) ??
                                    intl.none,
                                intl.remainingWeight),
                            pregnancy(),
                          ],
                        ),
                      ),
                      Space(height: 2.h),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 4.w, vertical: 1.5.h),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(intl.chartWeightName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                          color: AppColors.colorTextApp,
                                          fontWeight: FontWeight.bold)),
                              ...bloc.terms
                                  .map((e) => Padding(
                                        padding: EdgeInsets.only(top: 1.h),
                                        child: ChartWeight(e),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                      Space(height: 2.h),
                    ],
                  ),
                ),
              );
            } else
              return Container(height: 80.h, child: Progress());
          },
          stream: bloc.waiting,
        ),
      ),
    );
  }

  Widget itemUi(String unit, String? amount, String title) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(241, 241, 241, 1),
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Row(
        textDirection: context.textDirectionOfLocaleInversed,
        children: [
          Text(
            unit,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.overline,
          ),
          Space(width: 1.w),
          Text(
            amount ?? intl.none,
            textAlign: TextAlign.end,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.caption,
            ),
          ),
        ],
      ),
    );
  }

  Widget pregnancy() {
    return bloc.visitItem?.dietType == RegimeAlias.Pregnancy
        ? Column(
            children: [
              Space(height: 1.h),
              itemUi(
                  intl.kiloGr,
                  bloc.visitItem?.physicalInfo?.pregnancyIdealWeight
                          ?.toStringAsFixed(1) ??
                      0.toString(),
                  intl.pregnancyIdealWeight),
              Space(height: 1.h),
              itemUi(
                  intl.kiloGr,
                  bloc.visitItem?.physicalInfo?.idealWeightBasedOnPervVisit
                          ?.toStringAsFixed(1) ??
                      '',
                  intl.idealWeightBasedOnPervVisit),
              Space(height: 1.h),
              itemUi(
                  intl.kiloGr,
                  bloc.visitItem?.physicalInfo?.daysTillChildbirth
                          ?.toString() ??
                      0.toString(),
                  intl.daysTillChildbirth),
            ],
          )
        : Container();
  }

  String getDietTypeString() {
    if (bloc.visitItem != null) {
      switch (bloc.visitItem?.dietType) {
        case RegimeAlias.Pregnancy:
          return intl.pregnancy;
        case RegimeAlias.WeightLoss:
          return intl.weightLoss;

        case RegimeAlias.WeightGain:
          return intl.weightGain;

        case RegimeAlias.Stabilization:
          return intl.stabilization;

        case RegimeAlias.Diabeties:
          return intl.diabetes;

        case RegimeAlias.Ketogenic:
          return intl.ketogenic;
        case RegimeAlias.Sport:
          return intl.sport;
        case RegimeAlias.Notrica:
          return intl.notrica;
        default:
          return intl.none;
      }
    } else
      return intl.none;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  void onRetryLoadingPage() {
    bloc.onRetryLoadingPage();
  }
}
