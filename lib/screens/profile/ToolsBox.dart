import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/call_bax_profile.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:flutter/material.dart';

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
        Flexible(
          flex: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(flex: 1, child: optionUi(Icons.lock, intl.changePassword, 0)),
              SizedBox(width: 5.w),
//                  _optionUi(Icons.add, 'افزایش موجودی', 1),
              Expanded(flex: 1, child: optionUi(Icons.edit, intl.editProfile, 2)),
            ],
          ),
        ),
        SizedBox(height: 1.h),
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
}
