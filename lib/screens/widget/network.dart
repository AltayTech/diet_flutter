import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class NetworkAlertPage extends StatefulWidget {
  const NetworkAlertPage({Key? key}) : super(key: key);

  @override
  State createState() => _NetworkAlertState();
}

class _NetworkAlertState extends ResourcefulState<NetworkAlertPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 2.w),
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        width: 90.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              shape: AppShapes.rectangleDefault,
              child: Center(
                child: content(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Space(height: 1.h),
        ImageUtils.fromLocal('assets/images/no_internet.svg', width: 60.w),
        Space(height: 5.h),
        Text(intl.noInternetTitle, style: typography.headline6),
        Space(height: 1.h),
        Text(intl.noInternetMessage, style: typography.bodyText1),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 3.h),
          child: retryButton(),
        ),
      ],
    );
  }

  Widget retryButton() {
    return MaterialButton(
      padding: EdgeInsets.zero,
      color: AppColors.primary,
      minWidth: double.infinity,
      onPressed: () => Navigator.pop(context),
      shape: AppShapes.rectangleMedium,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 0.1.h),
        height: 7.h,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: ImageUtils.fromLocal(
                'assets/icon/retry_curved_edge.svg',
                color: AppColors.onPrimary.withOpacity(0.15),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                intl.retry,
                style: typography.button,
              ),
            ),
          ],
        ),
      ),
    );
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