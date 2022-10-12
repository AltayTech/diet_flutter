import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/screens/food_list/appbar_box_advice_video.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/screens/food_list/change_menu.dart';
import 'package:behandam/screens/food_list/food_list_appbar.dart';
import 'package:behandam/screens/food_list/food_meals.dart';
import 'package:behandam/screens/food_list/provider.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class FoodListPage extends StatefulWidget {
  const FoodListPage({Key? key}) : super(key: key);

  @override
  _FoodListPageState createState() => _FoodListPageState();
}

class _FoodListPageState extends ResourcefulState<FoodListPage> {
  late FoodListBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = FoodListBloc();
    bloc.getFoodMenu(fillFood: true);
    initListener();
  }

  void initListener() {
    bloc.showServerError.listen((event) {
      Navigator.of(context).pop();
    });

    bloc.navigateTo.listen((event) {
      if (event.contains('payment/bill')) {
        context.vxNav
            .clearAndPush(Uri.parse('/${event.toString().split('/')[0]}${Routes.regimeType}'));
      } else if (event.contains('survey')) {
        context.vxNav.push(Uri.parse(Routes.surveyCallSupport), params: bloc.getSurveyData);
      } else if (!Routes.listView.contains(event)) {
        context.vxNav.clearAndPush(Uri.parse('/$event'));
      } else
        context.vxNav.replace(Uri.parse('/$event'));
    });

    bloc.popLoading.listen((event) {
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
    return FoodListProvider(
      bloc,
      child: body(),
    );
  }

  Widget body() {
    return StreamBuilder(
      stream: bloc.loadingContent,
      initialData: true,
      builder: (_, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData && !snapshot.requireData)
          return Scaffold(
            body: SafeArea(
              child: Container(
                height: 100.h,
                child: Column(
                  children: [
                    Expanded(
                      child: TouchMouseScrollable(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  FoodListAppbar(),
                                  AppbarBoxAdviceVideo(),
                                ],
                              ),
                              Space(height: 2.h),
                              ChangeMenu(),
                              Space(height: 2.h),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: FoodMeals(),
                              ),
                              Space(
                                height: 1.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 3.w),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                                  child: InkWell(
                                      onTap: () {
                                        DialogUtils.showDialogProgress(context: context);
                                        bloc.checkFitamin();
                                        // _launchURL(vitrinBloc.url);
                                      },
                                      child: ImageUtils.fromLocal(
                                        (MemoryApp.userInformation != null &&
                                                MemoryApp.userInformation!.hasFitaminService
                                                    .isNullOrFalse)
                                            ? 'assets/images/vitrin/fitamin_banner_02.png'
                                            : 'assets/images/vitrin/fitamin_banner.png',
                                      )),
                                ),
                              ),
                              Space(
                                height: 2.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    BottomNav(currentTab: BottomNavItem.DIET),
                  ],
                ),
              ),
            ),
          );
        return Scaffold(
            appBar: Toolbar(titleBar: intl.foodList),
            body: SafeArea(
                child: Container(
                    height: 100.h,
                    child: Column(children: [
                      Expanded(child: Center(child: Progress())),
                      BottomNav(currentTab: BottomNavItem.DIET)
                    ]))));
      },
    );
  }

  @override
  void onRetryLoadingPage() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    bloc.onRetryLoadingPage();
    bloc.getFoodMenu(fillFood: true);
  }

  @override
  void onRetryAfterNoInternet() {
    //if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    //bloc.onRetryAfterNoInternet();
  }
}
