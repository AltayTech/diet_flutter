import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/screens/regime/menu/bloc.dart';
import 'package:behandam/screens/regime/menu/item.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
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
    return SingleChildScrollView(
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
    );
  }

  Widget menus(List<MenuType> menus) {
    return Column(
      children: [
        Text(
          intl.howMuchIsYourDailyActivity,
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
                  decoration: AppDecorations.boxMedium.copyWith(
                    color: AppColors.box,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    children: [
                      Space(height: 2.h),
                      ...menuType.menus
                          .map((menu) => MenuItem(
                                menu: menu,
                                onClick: () {
                                  DialogUtils.showDialogProgress(
                                      context: context);
                                  bloc.onItemClick(menu);
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

  // Widget menuItem(Menu menu) {
  //   return GestureDetector(
  //     onTap: (){
  //
  //     },
  //     child: Container(
  //       margin: EdgeInsets.only(bottom: 2.h),
  //       decoration: AppDecorations.boxLarge.copyWith(
  //         color: AppColors.onPrimary,
  //       ),
  //       padding:
  //       EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
  //       child: Row(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   menu.title,
  //                   style: typography.caption,
  //                   textAlign: TextAlign.start,
  //                 ),
  //                 Space(height: 0.2.h),
  //                 Text(
  //                   menu.description ?? '',
  //                   style: typography.caption?.apply(
  //                     fontSizeDelta: -2,
  //                   ),
  //                   textAlign: TextAlign.start,
  //                   softWrap: true,
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Space(width: 2.w),
  //           helpBox(),
  //         ],
  //       ),
  //     ),
  //   );
  // }
  //
  // Widget helpBox() {
  //   return Container(
  //     decoration: AppDecorations.boxMedium.copyWith(
  //       color: AppColors.primary.withOpacity(0.2),
  //     ),
  //     width: 15.w,
  //     height: 15.w,
  //     child: Center(
  //       child: ImageUtils.fromLocal(
  //         'assets/images/diet/help_icon.svg',
  //         width: 6.w,
  //         color: AppColors.iconsColor,
  //       ),
  //     ),
  //   );
  // }

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
