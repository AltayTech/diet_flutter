import 'dart:async';
import 'dart:io';

import 'package:behandam/base/network_response.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
import 'package:rxdart/rxdart.dart';

class MaintenancePage extends StatefulWidget {
  NetworkResponse error;

  MaintenancePage({Key? key, required this.error}) : super(key: key);

  @override
  State createState() => _MaintenanceState();
}

class _MaintenanceState extends ResourcefulState<MaintenancePage>
    with SingleTickerProviderStateMixin {
  final _ReminderTime = BehaviorSubject<String>();
  int second = 0;
  late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    second = int.parse(widget.error.remainingTime!.split('.').first);
    const oneSec = const Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (second - 1 <= 0) {
        second = 0;
      } else
        second -= 1;

      formatTime(second);
    });
  }

  void formatTime(int seconds) {
    _ReminderTime.safeValue = '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
    debugPrint("${_ReminderTime.valueOrNull}");
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Card(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          shape: AppShapes.rectangleDefault,
          child: content(),
        ),
      ],
    );
  }

  Widget content() {
    return Column(
      children: [
        Space(height: 4.h),
        ImageUtils.fromLocal(
          'assets/images/maintenance.png',
          height: 35.h,
          width: 60.w,
        ),
        Padding(
          padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 4.h),
          child: Text(
            widget.error.message ?? intl.maintenanceError,
            textAlign: TextAlign.center,
            style: typography.caption,
          ),
        ),
        StreamBuilder<String?>(
          builder: (context, time) {
            if (time.hasData)
              return Padding(
                padding: EdgeInsets.only(left: 5.w, right: 5.w, top: 2.h),
                child: Text(
                  time.data ?? '',
                  textAlign: TextAlign.center,
                  style: typography.caption,
                ),
              );
            else
              return EmptyBox();
          },initialData: "0",
          stream: _ReminderTime,
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.h, bottom: 2.h, left: 5.w, right: 5.w),
          child: retryButton(),
        ),
      ],
    );
  }

  Widget retryButton() {
    return MaterialButton(
      color: AppColors.primary,
      minWidth: double.infinity,
      onPressed: () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      height: 6.h,
      shape: AppShapes.rectangleSmall,
      child: Text(
        intl.understand,
        style: typography.button,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _ReminderTime.close();
    _timer.cancel();
  }
}
