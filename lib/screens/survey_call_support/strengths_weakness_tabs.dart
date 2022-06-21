import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/survey_call_support/strengths_tab.dart';
import 'package:behandam/screens/survey_call_support/weakness_tab.dart';
import 'package:behandam/screens/widget/custom_tabbar.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';

class StrengthsWeaknessTabs extends StatefulWidget {
  @override
  State createState() => StrengthsWeaknessTabsState();
}

class StrengthsWeaknessTabsState extends ResourcefulState<StrengthsWeaknessTabs>
    with TickerProviderStateMixin {
  late List<ItemTab> _list = [];
  late List<Widget> _listTabView = [];
  late TabController _controller;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    _listTabView.clear();
    _listTabView.add(StrengthsTab());
    _listTabView.add(WeaknessTab());

    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );

    if (_list.isEmpty) {
      _list.clear();
      _list.add(ItemTab(title: intl.strengths));
      _list.add(ItemTab(title: intl.weakness));
    }

    return Container(
        /*color: CustomColors.background,*/
        child: Column(
          children: [
            Container(
              height: 6.h,
              child: CustomTabBarUnderLineIndicator(Colors.white, _list, _controller),
            ),
            Container(
              height: 1000,
              child: TabBarView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: _listTabView,
              ),
            ),
          ],
        )
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
