import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/pedometer/bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class PedometerPage extends StatefulWidget {
  const PedometerPage({Key? key}) : super(key: key);

  @override
  State<PedometerPage> createState() => _PedometerPageState();
}

class _PedometerPageState extends ResourcefulState<PedometerPage> {
  late PedometerBloc bloc;
  String? previousName;

  @override
  void initState() {
    super.initState();
    bloc = PedometerBloc();

    checkPermission();

    bloc.startPedometer();
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
      appBar: Toolbar(titleBar: intl.pedometer),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: StreamBuilder<double>(
            initialData: 0,
            stream: bloc.stepCountBlocStream,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [pedometer(snapshot.data!.toInt(), StepCountStatus.WALKING)],
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
    return Column(children: [pedometerRadialGauge(stepCount, status), pedometerInfo()]);
  }

  Widget pedometerRadialGauge(int stepCount, StepCountStatus status) {
    return SfRadialGauge(axes: <RadialAxis>[
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
                    ImageUtils.fromLocal('assets/images/pedometer/shoe.svg'),
                    Space(height: 2.h),
                    Text('$stepCount',
                        style: typography.bodyLarge!
                            .copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                    Space(height: 2.h),
                    Text('6000',
                        style: typography.bodyLarge!.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary)),
                    Text(intl.goal,
                        style: typography.bodyLarge!
                            .copyWith(fontSize: 14.sp, fontWeight: FontWeight.bold))
                  ],
                ),
                angle: 90,
                positionFactor: 0.5)
          ])
    ]);
  }

  Widget pedometerInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(
          children: [
            ImageUtils.fromLocal('assets/images/pedometer/calorie_burn.svg'),
            Text(
              '399',
              style: typography.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'kcal',
              style: typography.labelSmall,
            )
          ],
        ),
        Column(
          children: [
            ImageUtils.fromLocal('assets/images/pedometer/watch.svg'),
            Text(
              '159',
              style: typography.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              'min',
              style: typography.labelSmall,
            )
          ],
        ),
        Column(children: [
          ImageUtils.fromLocal('assets/images/pedometer/kilometer.svg'),
          Text(
            '6',
            style: typography.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            'km',
            style: typography.labelSmall,
          )
        ]),
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
