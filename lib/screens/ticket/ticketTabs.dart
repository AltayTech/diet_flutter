import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/ticket/call_ticket.dart';
import 'package:behandam/screens/ticket/ticket.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/custom_tabbar.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';

class TicketTab extends StatefulWidget {
  @override
  State createState() => TicketTabState();
}

class TicketTabState extends ResourcefulState<TicketTab> with SingleTickerProviderStateMixin {
  late List<ItemTab> _list = [];
  late List<Widget> _listTabView = [];
  late TabController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _listTabView.clear();
    _listTabView.add(Ticket());
    _listTabView.add(CallTicket());


    _controller = TabController(
      vsync: this,
      length: 2,
      initialIndex: 0,
    );
    // getData();
  }

  void setFont() async {
    // await Multilanguage.setLanguage(path: Languages.fa,languageApp: LanguageApp.Farsi, context: context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void getData() {}

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_list.isEmpty)
      {
        _list.clear();
        _list.add(ItemTab(title: intl.message));
        _list.add(ItemTab(title: intl.call));
      }
    return Scaffold(
        appBar: Toolbar(titleBar: intl.ticket),
        body: SafeArea(
          child: Container(
            /*color: CustomColors.background,*/
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    height: 6.h,
                    margin: EdgeInsets.only(left: 16,right: 16,top: 16),
                    child: CustomTabBar(Colors.white, _list, _controller),
                  ),
                  flex: 0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 16, right: 16),
                    height: 1000,
                    child: TabBarView(
                      controller: _controller,
                      physics: NeverScrollableScrollPhysics(),
                      children: _listTabView,
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: BottomNav(currentTab: BottomNavItem.SUPPORT),
                  flex: 0,
                ),
              ],
            ),
          ),
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
