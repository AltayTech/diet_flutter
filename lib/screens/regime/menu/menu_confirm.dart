import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/screens/regime/menu/item.dart' as item;
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';
import 'bloc.dart';

class MenuConfirmPage extends StatefulWidget {
  const MenuConfirmPage({Key? key}) : super(key: key);

  @override
  _MenuConfirmPageState createState() => _MenuConfirmPageState();
}

class _MenuConfirmPageState extends ResourcefulState<MenuConfirmPage> {
  late MenuSelectBloc bloc;
  bool isInit=false;
  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      bloc = ModalRoute
          .of(context)!
          .settings
          .arguments as MenuSelectBloc;
    }
  }
  @override
  void initState() {
    super.initState();
    bloc = MenuSelectBloc();
    initListener();
  }

  void initListener() {
    bloc.navigateTo.listen((event) {
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
      appBar: Toolbar(titleBar: intl.confirmMenuList),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: content(),
          ),
        ),
      ),
    );
  }

  Widget content(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ImageUtils.fromLocal(kdjf),
        Text(
          intl.confirmMenuList,
          style: typography.caption,
          textAlign: TextAlign.center,
        ),
        Space(height: 2.h),
        Text(
          intl.areYouSureAboutMenu,
          style: typography.caption,
          textAlign: TextAlign.center,
        ),
        Space(height: 2.h),
        menu(),
        buttons(),
      ],
    );
  }

  Widget menu(){
    return StreamBuilder(
      stream: bloc.selectedMenu,
      builder: (_, AsyncSnapshot<Menu?> snapshot) {
        if (snapshot.hasData)
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            child: Container(
              decoration: AppDecorations.boxMedium.copyWith(
                color: AppColors.box,
              ),
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: Column(
                children: [
                  Space(height: 2.h),
                  item.MenuItem(
                    menu: snapshot.requireData!,
                    onClick: () {},
                  ),
                ],
              ),
            ),
          );
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget buttons(){
    return Column(
      children: [
        Center(
          child: SubmitButton(
            label: intl.yesWantThisMenu,
            onTap: () {
              DialogUtils.showDialogProgress(context: context);
              bloc.term();
            },
          ),
        ),
        Space(height: 2.h),
        TextButton(
          onPressed: () {
            if (VxNavigator.of(context).pages.length > 1)
              VxNavigator.of(context).pop();
            else
              VxNavigator.of(context).push(Uri(path: Routes.menuSelect));
          },
          child: Text(
            intl.noWannaChange,
            style: typography.caption?.apply(
              color: AppColors.labelColor,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
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
