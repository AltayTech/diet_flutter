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
    return CallBoxProfile();
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
