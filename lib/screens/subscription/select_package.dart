import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';

class SelectPackageSubscriptionScreen extends StatefulWidget {
  const SelectPackageSubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SelectPackageSubscriptionScreenState createState() => _SelectPackageSubscriptionScreenState();
}

class _SelectPackageSubscriptionScreenState
    extends ResourcefulState<SelectPackageSubscriptionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.selectPackageToolbar),
        body: body());
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            textDirection: context.textDirectionOfLocale,
            children: [
              Container(
                width: 80.w,
                decoration: AppDecorations.boxSmall.copyWith(
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(top: 2.h),
                padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 1.h, bottom: 1.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  textDirection: context.textDirectionOfLocale,
                  children: [
                    ImageUtils.fromLocal("assets/images/bill/subscription.svg",
                        width: 5.w, height: 5.w),
                    Space(
                      width: 2.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "121روز",
                          style: typography.titleSmall!.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "تا پایان دوره رژیم شما",
                          style: typography.subtitle2!.copyWith(fontWeight: FontWeight.w300),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
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
  void onShowMessage(String value) {}
}
