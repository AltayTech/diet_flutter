import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/screens/regime/regime_bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image/image.dart';
import 'package:logifan/widgets/space.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../routes.dart';

class HelpTypeScreen extends StatefulWidget {
  const HelpTypeScreen({Key? key}) : super(key: key);

  @override
  _HelpTypeScreenState createState() => _HelpTypeScreenState();
}

class _HelpTypeScreenState extends ResourcefulState<HelpTypeScreen> {
  late RegimeBloc regimeBloc;
  late HelpPage helpType;

  @override
  void initState() {
    super.initState();
    regimeBloc = RegimeBloc();
    listenBloc();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    helpType = ModalRoute.of(context)!.settings.arguments as HelpPage;
    regimeBloc.helpMethod(helpType == HelpPage.regimeType ? 1 : 2);
  }

  void listenBloc() {
    regimeBloc.showServerError.listen((event) {
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: Toolbar(titleBar: intl.whichRegime),
      body: body(),
    );
  }

  Widget body(){
    return SingleChildScrollView(
      child: Card(
        shape: AppShapes.rectangleMedium,
        elevation: 1,
        margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              StreamBuilder(
                stream: regimeBloc.helpTitle,
                builder: (_, AsyncSnapshot<String> snapshot) {
                  return Text(
                    snapshot.data ?? '',
                    style: typography.subtitle2,
                  );
                },
              ),
              Space(height: 1.h),
              helps(),
              SizedBox(height: 5.h)
            ],
          ),
        ),
      ),
    );
  }

  Widget item(Help help) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: ClipRRect(
        borderRadius: AppBorderRadius.borderRadiusSmall,
        child: Container(
          color: AppColors.primary.withOpacity(0.1),
          padding: EdgeInsets.only(right: 3.w),
          child: Container(
            color: AppColors.box,
            padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.h),
            child: Text(
              help.body ?? '',
              style: typography.caption,
            ),
          ),
        ),
      ),
    );
  }

  Widget helps(){
    return StreamBuilder(
      stream: regimeBloc.helpers,
      builder: (context, AsyncSnapshot<List<Help>> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...snapshot.requireData
                  .map((help) => item(help))
                  .toList(),
            ],
          );
        } else {
          return Center(
            child: Container(
              width: 15.w,
              height: 15.w,
              child: CircularProgressIndicator(
                  color: Colors.grey, strokeWidth: 1.0),
            ),
          );
        }
      },
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
