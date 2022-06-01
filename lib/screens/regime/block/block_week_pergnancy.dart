import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';


class BlockPregnancy extends StatefulWidget {
  const BlockPregnancy({Key? key}) : super(key: key);

  @override
  State<BlockPregnancy> createState() => _BlockPregnancyState();
}

class _BlockPregnancyState extends ResourcefulState<BlockPregnancy> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.blockPregnancyToolbar),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  shape: AppShapes.rectangleMild,
                  elevation: 2,
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: content(),
                  ),
                ),
              ),
            ),
            BottomNav(currentTab: BottomNavItem.DIET),
          ],
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Space(height: 1.h),
        ImageUtils.fromLocal(
          'assets/images/foodlist/pregnancy/pregnancy_4.svg',
        width: 40.w,
          height: 40.w
        ),
        Space(height: 1.h),
        titleText(),
        Space(height: 2.h),
        alertText(),
        Space(height: 2.h),
      ],
    );
  }
  Widget titleText() {
    return Text(
      intl.blockPregnancyTitle,
      style: typography.titleSmall!.copyWith(fontWeight: FontWeight.bold,fontSize: 14.sp),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }
  Widget alertText() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: Text(
        intl.blockPregnancyText,
        style: typography.caption,
        softWrap: true,
        textAlign: TextAlign.center,
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
