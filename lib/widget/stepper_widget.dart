import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:flutter/material.dart';

/// Created by Luciferx86 on 08/09/20.
class StepperWidget extends StatelessWidget {
  late ProgressTimeline _progressTimeline;

  StepperWidget() {
    _progressTimeline = progressTimeline();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Future.delayed(Duration(milliseconds: 200), () {
        try {
          _progressTimeline.gotoStage(MemoryApp.page);
        } catch (e) {}
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(child: _progressTimeline);
  }

  ProgressTimeline progressTimeline() {
    return ProgressTimeline(
      states: [
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
        SingleState(stateTitle: "", isFailed: false),
      ],
      height: 5.h,
      width: 40.w,
      checkedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 28, height: 28, fit: BoxFit.fill),
      currentIcon: ImageUtils.fromLocal("assets/images/physical_report/current_step.svg",
          width: 28, height: 28, fit: BoxFit.fill),
      failedIcon: ImageUtils.fromLocal("assets/images/physical_report/checked_step.svg",
          width: 28, height: 28, fit: BoxFit.fill),
      uncheckedIcon: ImageUtils.fromLocal("assets/images/physical_report/none_step.svg",
          width: 15, height: 15, fit: BoxFit.fill),
      iconSize: 28,
      connectorLength: 10.w,
      connectorColorSelected: AppColors.primary,
      connectorWidth: 4,
      connectorColor: Color(0xffC9D1E1),
    );
  }
}
