import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/call_bax_profile.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class ToolsBox extends StatefulWidget {
  @override
  State createState() => ToolsBoxState();
}

class ToolsBoxState extends ResourcefulState<ToolsBox> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return body();
  }

  Widget body() {
    return Column(
      children: [
        optionButtonUi(Icons.list_alt_outlined, intl.historySubscriptionPayment, 0,context.textDirectionOfLocale),
        Space(height: 2.h),
        Flexible(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(flex: 1, child: optionButtonUi(Icons.lock, intl.changePassword, 0,context.textDirectionOfLocale)),
              Space(width: 2.w),
//                  _optionUi(Icons.add, 'افزایش موجودی', 1),
              Expanded(flex: 1, child: optionButtonUi(Icons.edit, intl.editProfile, 2,context.textDirectionOfLocale)),
            ],
          ),
        ),
        Space(height: 1.h),
        Flexible(flex: 0, child: CallBoxProfile()),
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
