import 'dart:io';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/screens/pedometer/bloc.dart';
import 'package:behandam/screens/widget/custom_button.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class PedometerPage extends StatefulWidget {
  const PedometerPage({Key? key}) : super(key: key);

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends ResourcefulState<PedometerPage> {
  late PedometerBloc bloc;
  String? previousName;
  late List<_ChartData> data;

  @override
  void initState() {
    super.initState();

    bloc = PedometerBloc();

    if (AppSharedPreferences.pedometerOn) {
      checkPermission();
    }

    bloc.pedometerOn.listen((event) {
      if (event) {
        checkPermission();
      } else {
        bloc.stopPedometer();
      }
    });

    data = [
      _ChartData('17', 2500),
      _ChartData('18', 4000),
      _ChartData('19', 8000),
      _ChartData('20', 7000),
      _ChartData('21', 5500),
      _ChartData('22', 3000),
      _ChartData('23', 4500),
      _ChartData('24', 3400),
      _ChartData('Today', 6200),
    ];
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.appName),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: StreamBuilder<double>(
            initialData: 0,
            stream: bloc.stepCountBlocStream,
            builder: (_, step) {
              if (step.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    pedometer(step.data!.toInt(), StepCountStatus.WALKING),
                    SfCartesianChart(
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                            minimum: 1000, maximum: 10000, interval: 1000),
                        series: <ChartSeries<_ChartData, String>>[
                          ColumnSeries<_ChartData, String>(
                            dataSource: data,
                            borderRadius: BorderRadius.circular(15),
                            width: 0.5,
                            spacing: 0.7,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Gold',
                            gradient: AppColors.pedometerChartColorsGradient,
                          )
                        ])
                  ],
                );
              } else {
                return pedometer(0, StepCountStatus.STOPPED);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget pedometer(int stepCount, StepCountStatus status) {
    return Column(
        children: [pedometerRadialGauge(stepCount, status), pedometerInfo()]);
  }

  Widget pedometerRadialGauge(int stepCount, StepCountStatus status) {
    return Stack(children: [
      SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: 6000,
            showLabels: true,
            showLastLabel: true,
            showFirstLabel: true,
            showTicks: false,
            showAxisLine: true,
            pointers: <GaugePointer>[
              MarkerPointer(value: stepCount.toDouble())
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                  widget: Column(
                    children: [
                      Space(height: 8.h),
                      Text('$stepCount',
                          style: typography.bodyLarge!.copyWith(
                              fontSize: 28.sp, fontWeight: FontWeight.bold)),
                      Space(height: 2.h),
                    ],
                  ),
                  angle: 90,
                  positionFactor: 0.5)
            ])
      ]),
      Positioned(
        left: 0,
        right: 0,
        top: 80,
        child: StreamBuilder<bool>(
          stream: bloc.pedometerOn,
          initialData: AppSharedPreferences.pedometerOn,
          builder: (context, pedometerOn) {
            return GestureDetector(
                onTap: () {
                  bloc.setPedometerOn(!pedometerOn.requireData);
                },
                child: pedometerOn.requireData
                    ? ImageUtils.fromLocal('assets/images/pedometer/shoe.svg')
                    : ImageUtils.fromLocal('assets/images/pedometer/shoe_off.svg'));
          }
        ),
      )
    ]);
  }

  Widget pedometerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            ImageUtils.fromLocal('assets/images/pedometer/calorie_burn.svg'),
            StreamBuilder<double>(
                stream: bloc.calorieBurnCount,
                initialData: 0,
                builder: (context, calorieBurn) {
                  if (calorieBurn.hasData) {
                    return Text(
                      calorieBurn.data!.toStringAsFixed(2),
                      style: typography.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    );
                  }
                  return Text(
                    '0',
                    style: typography.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  );
                }),
            Text(
              'kcal',
              style: typography.labelSmall,
            )
          ],
        ),
        Column(
          children: [
            ImageUtils.fromLocal('assets/images/pedometer/watch.svg'),
            StreamBuilder<int>(
                stream: bloc.minCount,
                initialData: 0,
                builder: (context, min) {
                  if (min.hasData) {
                    return Text(
                      min.data.toString(),
                      style: typography.bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    );
                  }
                  return Text(
                    '0',
                    style: typography.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  );
                }),
            Text(
              'min',
              style: typography.labelSmall,
            )
          ],
        ),
        Column(children: [
          ImageUtils.fromLocal('assets/images/pedometer/kilometer.svg'),
          StreamBuilder<double>(
              stream: bloc.kilometerCount,
              initialData: 0,
              builder: (context, kilometer) {
                if (kilometer.hasData) {
                  return Text(
                    kilometer.data!.toStringAsFixed(2),
                    style: typography.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  );
                }
                return Text(
                  '0',
                  style: typography.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold),
                );
              }),
          Text(
            'km',
            style: typography.labelSmall,
          )
        ])
      ]),
    );
  }

  Future<void> checkPermission() async {
    if (Platform.isAndroid && await getAndroidSdk() >= 29) {
      if (!await Permission.activityRecognition.isGranted) {
        Permission.activityRecognition.request().then((value) {
          if (value == PermissionStatus.granted) {
            bloc.startPedometer();
          }
        });
      } else {
        bloc.startPedometer();
      }
    } else {
      if (!await Permission.sensors.isGranted) {
        Permission.sensors.request().then((value) {
          if (value == PermissionStatus.granted) {
            bloc.startPedometer();
          }
        });
      } else {
        bloc.startPedometer();
      }
    }
  }

  Future<int> getAndroidSdk() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      return sdkInt;
    }
    return 0;
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
