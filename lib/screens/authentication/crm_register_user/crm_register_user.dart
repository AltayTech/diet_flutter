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

class CrmRegisterUser extends StatefulWidget {
  const CrmRegisterUser({Key? key}) : super(key: key);

  @override
  State<CrmRegisterUser> createState() => _CrmRegisterUserState();
}

class _CrmRegisterUserState extends ResourcefulState<CrmRegisterUser> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: ''),
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
        Space(height: 10.h),
        Text(
          intl.userCrmMessageSuccess,
          style: typography.caption,
          softWrap: true,
          textAlign: TextAlign.center,
        ),
        Space(height: 1.h),
        Center(
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: SubmitButton(
              label: intl.back,
              onTap: () {
                context.vxNav.clearAndPush(Uri.parse(Routes.listView));
              },
            ),
          ),
        ),
        Space(height: 2.h),
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
