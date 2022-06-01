import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/status/visit_item.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWeight extends StatefulWidget {
  late TermStatus term;

  ChartWeight(this.term);

  @override
  State createState() => ChartWeightState();
}

class ChartWeightState extends ResourcefulState<ChartWeight> {
  late ExpandableController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = ExpandableController();
    if(widget.term.isActive==1){
      _controller.toggle();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return charts();
  }

  Widget charts() {
    return Center(
        child: Container(
            height: _controller.expanded ? 30.h :12.h,
            padding: EdgeInsets.only(top: 5.w,left: 5.w,right: 5.w,bottom: 1.w),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height:3.h,
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(children: [
                          Expanded(
                          flex: 1,
                          child: FittedBox(
                            fit: context.isRtl?BoxFit.none:BoxFit.fitWidth,
                            child: Text( intl.dateStart,
                                style: Theme.of(context)
                                    .textTheme
                                    .overline!
                                    .copyWith(color: AppColors.colorTextApp, fontWeight: FontWeight.bold)),
                          )),
                          Expanded(
                            flex: 1,
                            child: FittedBox(
                              fit: context.isRtl?BoxFit.none:BoxFit.fitWidth,
                              child: Text( DateTimeUtils.gregorianToJalali(widget.term.startedAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(color: AppColors.greenRuler, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                          Expanded(
                          flex: 1,
                          child: FittedBox(
                            fit: context.isRtl?BoxFit.none:BoxFit.fitWidth,
                              child: Text( intl.dateEnd,
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(color: AppColors.colorTextApp, fontWeight: FontWeight.bold)),
                            )),
                            Expanded(
                              flex: 1,
                              child: FittedBox(
                                fit: context.isRtl?BoxFit.none:BoxFit.fitWidth,
                                child:Text( DateTimeUtils.gregorianToJalali(widget.term.expiredAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Space(height: 1.h,),
                if(widget.term.isActive==0)
                GestureDetector(
                  child: Text(
                    _controller.expanded ? intl.close : intl.viewChart,
                    style: Theme.of(context).textTheme.overline!.copyWith(color: AppColors.primary),
                    textAlign: TextAlign.center,
                  ),
                  onTap: () {
                    setState(() {
                      _controller.toggle();
                    });
                  },
                ),
                Expanded(
                  flex:1,
                  child:  ExpandableNotifier(
                    child: ExpandablePanel(
                      collapsed: Container(),
                      expanded: SfCartesianChart(
                        primaryXAxis: CategoryAxis(
                          labelRotation: 320,
                          interval: 1,
                          labelStyle: Theme.of(context).textTheme.overline,
                        ),
                        backgroundColor: AppColors.background,
                        primaryYAxis: NumericAxis(
                            minimum: widget.term.minWeight!.roundToDouble(),
                            maximum: widget.term.maxWeight!.roundToDouble() ,
                            interval: 10,
                            axisLine: AxisLine(color: Colors.transparent),
                            labelStyle: Theme.of(context).textTheme.overline),
                        tooltipBehavior: TooltipBehavior(enable: false),
                        borderWidth: 0.1.w,
                        series: <LineSeries<VisitStatus, String>>[
                          LineSeries<VisitStatus, String>(
                            // Bind data source
                              dataSource: widget.term.visits!,
                              xValueMapper: (VisitStatus v, _) => DateTimeUtils.gregorianToJalali(v.visitedAt)
                                  .substring(5, 10)
                                  .replaceAll('-', '/'),
                              yValueMapper: (VisitStatus v, _) => v.weight,
                              width: 2,
                              dataLabelSettings: DataLabelSettings(
                                  color: Colors.white,
                                  borderWidth: 1,
                                  borderColor: AppColors.primary,
                                  isVisible: true,
                                  textStyle: Theme.of(context)
                                      .textTheme
                                      .overline!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              markerSettings: const MarkerSettings(
                                isVisible: true,
                                borderWidth: 2,
                                borderColor: AppColors.chartBorder,
                              ))
                        ],
                        zoomPanBehavior: ZoomPanBehavior(
                            enableMouseWheelZooming: true,
                            enablePinching: true,
                            maximumZoomLevel: 3,
                            zoomMode: ZoomMode.x,
                            enablePanning: true
                        ),
                      ),
                      controller: _controller,
                    ),
                  ),

                ),
              ],
            ),),);
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
