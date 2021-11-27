import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class MenuSelectPage extends StatefulWidget {
  const MenuSelectPage({Key? key}) : super(key: key);

  @override
  _MenuSelectPageState createState() => _MenuSelectPageState();
}

class _MenuSelectPageState extends ResourcefulState<MenuSelectPage> {

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.selectYourMenu),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              intl.howMuchIsYourDailyActivity,
              style: typography.caption,
              textAlign: TextAlign.center,
            ),
            Space(height: 2.h),
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
