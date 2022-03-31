import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/screens/regime/menu/bloc.dart';
import 'package:behandam/screens/regime/menu/item.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class MenuSelectPage extends StatefulWidget {
  const MenuSelectPage({Key? key}) : super(key: key);

  @override
  _MenuSelectPageState createState() => _MenuSelectPageState();
}

class _MenuSelectPageState extends ResourcefulState<MenuSelectPage> {
  late MenuSelectBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = MenuSelectBloc();
    initListener();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  void initListener() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      if ('/$event' == Routes.listView)
        context.vxNav.clearAndPush(Uri.parse('/$event'));
      else
        context.vxNav.push(Uri.parse('/$event'), params: bloc);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.selectYourMenu),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: TouchMouseScrollable(
              child: SingleChildScrollView(
                child: Card(
                  shape: AppShapes.rectangleMedium,
                  elevation: 1,
                  margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                    child: StreamBuilder(
                      stream: bloc.menuTypes,
                      builder: (_, AsyncSnapshot<List<MenuType>> snapshot) {
                        if (snapshot.hasData) return menus(snapshot.requireData);
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          BottomNav(currentTab: BottomNavItem.DIET),
        ],
      ),
    );
  }

  Widget menus(List<MenuType> menus) {
    return Column(
      children: [
        Text(
          intl.selectYourMenu,
          style: typography.caption,
          textAlign: TextAlign.center,
        ),
        Space(height: 2.h),
        ...menus.map((menuType) => menuTypeBox(menuType)).toList(),
        Text(
          intl.whichMenuList,
          style: typography.caption,
          textAlign: TextAlign.center,
        ),
        InkWell(
          child: ImageUtils.fromLocal('assets/images/physical_report/guide.svg',
              width: 5.w, height: 5.h),
          onTap: () => VxNavigator.of(context).push(
            Uri.parse(Routes.helpType),
            params: HelpPage.menuType,
          ),
        ),
      ],
    );
  }

  Widget menuTypeBox(MenuType menuType) {
    return menuType.menus != null && menuType.menus.length > 0
        ? Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  menuType.title,
                  style: typography.caption,
                  textAlign: TextAlign.start,
                ),
                Container(
                  decoration: AppDecorations.boxMedium.copyWith(color: AppColors.box),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      Space(height: 2.h),
                      ...menuType.menus
                          .map((menu) => MenuItem(
                                menu: menu,
                                onClick: () {
                                  if (!navigator.currentConfiguration!.path
                                      .contains(Routes.listMenuSelect)) {
                                    DialogUtils.showDialogProgress(context: context);
                                    bloc.onItemClick(menu);
                                  } else
                                    dailyMenuDialog(menu);
                                },
                              ))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ),
          )
        : EmptyBox();
  }

  void dailyMenuDialog(Menu menu) {
    DialogUtils.showDialogPage(
      context: context,
      isDismissible: true,
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
          width: double.maxFinite,
          decoration: AppDecorations.boxLarge.copyWith(
            color: AppColors.onPrimary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              close(),
              Text(
                menu.title,
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                menu.description!,
                style: typography.caption,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Container(
                alignment: Alignment.center,
                child: SubmitButton(
                  onTap: () async {
                    Navigator.of(context).pop();
                    DialogUtils.showDialogProgress(context: context);
                    bloc.onItemClick(menu);
                  },
                  label: intl.yesSaveList,
                ),
              ),
              Space(height: 2.h),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Text(
                  intl.cancel,
                  style: typography.caption,
                  textAlign: TextAlign.center,
                ),
              ),
              Space(height: 1.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget close() {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        alignment: Alignment.topLeft,
        child: Container(
          decoration: AppDecorations.boxSmall.copyWith(
            color: AppColors.primary.withOpacity(0.4),
          ),
          padding: EdgeInsets.all(1.w),
          child: Icon(
            Icons.close,
            size: 6.w,
            color: AppColors.onPrimary,
          ),
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
