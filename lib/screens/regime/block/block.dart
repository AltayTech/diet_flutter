import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class Block extends StatefulWidget {
  const Block({Key? key}) : super(key: key);

  @override
  State<Block> createState() => _BlockState();
}

class _BlockState extends ResourcefulState<Block> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.needInvestigation),
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
        ImageUtils.fromLocal(
          'assets/images/bill/fail_pay.svg',
          width: 40.w,
          // height: 20.w,
        ),
        alertText(),
        Space(height: 2.h),
        apologyBox(),
        Space(height: 2.h),
        buttons(),
        Space(height: 3.h),
        Text(
          intl.callRightNow,
          style: typography.caption,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        Space(height: 1.h),
        Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SubmitButton(
              label: intl.phone,
              onTap: () async => await IntentUtils.makePhoneCall(intl.phone),
              icon: Icon(
                Icons.call,
                size: 5.w,
                color: AppColors.onPrimary,
              ),
            ),
          ),
        ),
        Space(height: 2.h),
      ],
    );
  }

  Widget alertText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.edit,
          size: 5.w,
          color: AppColors.primary,
        ),
        Space(width: 3.w),
        Expanded(
          child: Text(
            intl.blockText,
            style: typography.caption,
            softWrap: true,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }

  Widget apologyBox() {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 13.w,
                height: 3.h,
                decoration: BoxDecoration(
                  color: AppColors.box,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(70.0),
                      topRight: Radius.circular(70.0)),
                ),
              ),
            ),
            Container(
              decoration: AppDecorations.boxLarge.copyWith(
                color: AppColors.box,
              ),
              padding: EdgeInsets.fromLTRB(3.w, 3.h, 3.w, 2.h),
              child: Center(
                child: Text(
                  intl.blockApology,
                  style: typography.caption?.apply(
                    color: AppColors.greenRuler,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 5,
          right: 0,
          left: 0,
          child: ImageUtils.fromLocal(
            'assets/images/bill/happy_face.svg',
            width: 8.w,
            height: 8.w,
          ),
        ),
      ],
    );
  }

  Widget buttons() {
    return navigator.currentConfiguration!.path.contains('sick')
        ? Center(
            child: SubmitButton(
              label: intl.editSickness,
              onTap: () => context.vxNav.push(Uri(
                  path:
                      '/${navigator.currentConfiguration!.path.substring(1).split('/').first}/sick/select')),
            ),
          )
        : Column(
            children: [
              if (navigator.currentConfiguration!.path != Routes.listBlock)
                Center(
                  child: SubmitButton(
                    label: intl.selectAnotherRegime,
                    onTap: () => VxNavigator.of(context).push(Uri(
                        path:
                            '/${navigator.currentConfiguration!.path.substring(1).split('/').first}/diet/type')),
                  ),
                ),
              Space(height: 2.h),
              Center(
                child: SubmitButton(
                  label: intl.editPhysicalInfo,
                  onTap: () {
                    if (navigator.currentConfiguration!.path ==
                            Routes.listBlock ||
                        navigator.currentConfiguration!.path ==
                            Routes.renewBlock)
                      VxNavigator.of(context)
                          .push(Uri(path: Routes.weightEnter));
                    else
                      VxNavigator.of(context).push(Uri(path: Routes.bodyState));
                  },
                ),
              ),
            ],
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
