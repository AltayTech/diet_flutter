import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';

class DietGoalPage extends StatefulWidget {
  const DietGoalPage({Key? key}) : super(key: key);

  @override
  _DietGoalPageState createState() => _DietGoalPageState();
}

class _DietGoalPageState extends ResourcefulState<DietGoalPage> {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.dietGoal),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
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
