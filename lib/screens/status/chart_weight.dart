import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/status/bloc.dart';
import 'package:behandam/screens/status/status_provider.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartWeight extends StatefulWidget {
  ChartWeight();

  @override
  State createState() => ChartWeightState();
}

class ChartWeightState extends ResourcefulState<ChartWeight> {
  late StatusBloc _bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    _bloc = StatusProvider.of(context);
    return charts();
  }

  Widget charts() {
    return Center(
        child: Container(
            height: 30.h,
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: SfCartesianChart(
              title: ChartTitle(
                  text: intl.chartWeightName,
                  textStyle: Theme.of(context)
                      .textTheme
                      .caption!
                      .copyWith(color: AppColors.colorTextApp, fontWeight: FontWeight.bold)),
              primaryXAxis: CategoryAxis(
                labelRotation: 320,
                interval: 1,
                labelStyle: Theme.of(context).textTheme.overline,
              ),
              backgroundColor: Colors.white,
              primaryYAxis: NumericAxis(
                  minimum: _bloc.visitItem?.minWeight!.roundToDouble() ?? 0,
                  maximum: _bloc.visitItem?.maxWeight!.roundToDouble() ?? 100,
                  interval: 10,
                  axisLine: AxisLine(color: Colors.transparent),
                  labelStyle: Theme.of(context).textTheme.overline),
              tooltipBehavior: TooltipBehavior(enable: false),
              borderWidth: 0.1.w,
              series: <LineSeries<Visit, String>>[
                LineSeries<Visit, String>(
                    // Bind data source
                    dataSource: _bloc.visits,
                    xValueMapper: (Visit v, _) => DateTimeUtils.gregorianToJalali(v.visitedAt)
                        .substring(5, 10)
                        .replaceAll('-', '/'),
                    yValueMapper: (Visit v, _) => v.weight,
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
                enablePanning: true,
              ),
            )));
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
