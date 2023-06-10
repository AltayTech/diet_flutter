import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/screens/advice/bloc.dart';
import 'package:behandam/screens/pedometer/bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
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
          child: StreamBuilder<int>(
            stream: bloc.stepCountBlocStream,
            builder: (_, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [pedometerRadialGauge(snapshot.requireData, bloc.getLastStepStatus)],
                );
              }
              return pedometerRadialGauge(300, StepCountStatus.STOPPED);
            },
          ),
        ),
      ),
    );
  }

  Widget pedometerRadialGauge(int stepCount, StepCountStatus status) {
    return SfRadialGauge(axes: <RadialAxis>[
      RadialAxis(minimum: 0, maximum: 5000, pointers: <GaugePointer>[
        MarkerPointer(value: stepCount.toDouble())
      ], annotations: <GaugeAnnotation>[
        GaugeAnnotation(
            widget: Column(
              children: [
                ImageUtils.fromLocal('assets/images/pedometer/shoe.svg'),
                Space(height: 2.h),
                Text('$stepCount',
                    style: typography.bodyLarge!
                        .copyWith(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                Space(height: 2.h),
                Text('5000',
                    style: typography.bodyLarge!.copyWith(
                        fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primary)),
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
