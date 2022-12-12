import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/food_list_appbar.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/food_list/week_day.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class AlertFlowPage extends StatefulWidget {
  const AlertFlowPage({Key? key}) : super(key: key);

  @override
  _AlertFlowPageState createState() => _AlertFlowPageState();
}

class _AlertFlowPageState extends ResourcefulState<AlertFlowPage> {
  late FoodListBloc bloc;
  Map<String, dynamic>? textItem;

  @override
  void initState() {
    super.initState();
    bloc = FoodListBloc.fillWeek();
    listen();
  }

  void listen() {
    bloc.navigateTo.listen((event) {
      context.vxNav.push(Uri.parse('/$event'));
    });
    bloc.showServerError.listen((event) {
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    textItem = getTextAlert(navigator.currentConfiguration?.path ?? Routes.listMenuAlert);
    return FoodListProvider(
      bloc,
      child: Scaffold(
        appBar: Toolbar(titleBar: textItem!['appbar']),
        body: SafeArea(child: body()),
      ),
    );
  }

  Widget body() {
    return StreamBuilder(
      stream: bloc.loadingContent,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        return Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Stack(
                        children: [
                          FoodListAppbar(
                            showToolbar: false,
                            isClickable: false,
                          ),
                          appbarStackBox(),
                        ],
                      ),
                      Space(height: 7.h),
                      ImageUtils.fromLocal(textItem!['icon'], width: 20.w, height: 20.w),
                      Space(height: 2.h),
                      Padding(
                        padding: EdgeInsets.only(left: 4.w, right: 4.w),
                        child: Text(
                          textItem!['text'],
                          textAlign: TextAlign.center,
                          textDirection: context.textDirectionOfLocale,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      Space(height: 4.h),
                      Center(
                        child: SubmitButton(
                          label: textItem!['btnLabel'],
                          onTap: () {
                            DialogUtils.showDialogProgress(context: context);
                            bloc.nextStep();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              BottomNav(currentTab: BottomNavItem.DIET),
            ],
          ),
        );
      },
    );
  }

  Map<String, dynamic> getTextAlert(String routeName) {
    switch (routeName) {
      case Routes.listMenuAlert:
        // analytics.logEvent(name: "list_menu_alert");
        return {
          'appbar': intl.getNewList,
          'icon': 'assets/images/foodlist/list_alert.svg',
          'text': intl.descriptionNewList,
          'btnLabel': intl.getNewList,
        };
      case Routes.listWeightAlert:
        // analytics.logEvent(name: "weight_alert");
        return {
          'appbar': intl.visit,
          'icon': 'assets/images/diet/pupop_weight_icon.svg',
          'text': intl.descriptionVisit,
          'btnLabel': intl.continues,
        };
      case Routes.renewAlert:
        //analytics.logEvent(name: "renew_alert");
        return {
          'appbar': intl.reviveDiet,
          'icon': 'assets/images/foodlist/list_alert.svg',
          'text': intl.descriptionRenew,
          'btnLabel': intl.reviveDiet,
        };
      case Routes.reviveAlert:
        // analytics.logEvent(name: "renew_alert");
        return {
          'appbar': intl.reviveDiet,
          'icon': 'assets/images/foodlist/list_alert.svg',
          'text': intl.descriptionRevive,
          'btnLabel': intl.reviveDiet,
        };
      default:
        return {
          'appbar': intl.reviveDiet,
          'icon': 'assets/images/foodlist/list_alert.svg',
          'text': intl.descriptionRevive,
          'btnLabel': intl.reviveDiet,
        };
    }
  }

  Widget appbarStackBox() {
    return Positioned(
      bottom: 0,
      right: 0,
      left: 0,
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 3.w),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          child: StreamBuilder(
            stream: bloc.selectedWeekDay,
            builder: (_, AsyncSnapshot<WeekDay?> snapshot) {
              if (snapshot.hasData) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        appbarStackBoxText(snapshot.requireData!),
                        style: typography.caption,
                        softWrap: true,
                      ),
                    ),
                    SubmitButton(
                      label: isToday(snapshot.requireData!) ? intl.showAdvices : intl.goToToday,
                      size: Size(40.w, 5.h),
                      onTap: () {

                      },
                    ),
                  ],
                );
              }
              return Center(child: Progress());
            },
          ),
        ),
      ),
    );
  }

  String appbarStackBoxText(WeekDay weekday) {
    String text = '';
    if (isToday(weekday)) {
      debugPrint('format ${weekday.jalaliDate.formatter.dd}');
      text = intl.todayAdvicesForYou;
    } else {
      text = intl.viewingMenu(
          '${weekday.jalaliDate.formatter.wN} ${weekday.jalaliDate.formatter.d} ${weekday.jalaliDate.formatter.mN}');
    }
    return text;
  }

  bool isToday(WeekDay weekDay) {
    return weekDay.gregorianDate.toString().substring(0, 10) ==
        DateTime.now().toString().substring(0, 10);
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
