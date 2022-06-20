import 'dart:io';

import 'package:flutter/material.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/services.dart';
import 'package:logifan/widgets/space.dart';
class MaintenancePage extends StatefulWidget {
  String? message;
   MaintenancePage({Key? key,required this.message}) : super(key: key);

  @override
  State createState() => _MaintenanceState();
}

class _MaintenanceState extends ResourcefulState<MaintenancePage> {

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
            widget.message ?? intl.maintenanceError,
            textAlign: TextAlign.center,
            style: typography.caption,
          ),
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
      onPressed:  () {
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else if (Platform.isIOS) {
          exit(0);
        }
      },
      height: 6.h,
      shape: AppShapes.rectangleSmall,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageUtils.fromLocal('assets/icon/retry.svg'),
          Space(width: 8),
          Text(
            intl.understand,
            style: typography.button,
          ),
        ],
      ),
    );
  }

}
