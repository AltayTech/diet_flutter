import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/survey_call_support/strengths_tab.dart';
import 'package:behandam/screens/survey_call_support/weakness_tab.dart';
import 'package:behandam/screens/widget/custom_tabbar.dart';
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
  late SurveyCallSupportBloc bloc;

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = SurveyCallSupportProvider.of(context);

    _listTabView.clear();
    _listTabView.add(WeaknessTab());
    _listTabView.add(StrengthsTab());

    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );

    bloc.tabController = _controller;

    if (_list.isEmpty) {
      _list.clear();
      _list.add(ItemTab(title: intl.weakness));
      _list.add(ItemTab(title: intl.strengths));
    }

    return Container(
        /*color: CustomColors.background,*/
        child: Column(
      children: [
        Container(
          height: 6.h,
          child: StreamBuilder<PollPhrases>(
              stream: bloc.isContactedToMe,
              builder: (context, isContactedToMe) {
                if (isContactedToMe.hasData &&
                    isContactedToMe.requireData.isActive! == boolean.True) {
                  return CustomTabBarUnderLineIndicator(
                      Colors.white, _list, _controller, Colors.grey);
                } else {
                  return CustomTabBarUnderLineIndicator(
                      Colors.white, _list, _controller, null);
                }
              }),
        ),
        Container(
          height: 30.h,
          child: TabBarView(
            controller: _controller,
            physics: NeverScrollableScrollPhysics(),
            children: _listTabView,
          ),
        ),
      ],
    ));
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
