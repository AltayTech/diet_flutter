import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/screens/regime/target_weight/bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/bottom_nav.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../routes.dart';

class TargetWeightScreen extends StatefulWidget {
  const TargetWeightScreen({Key? key}) : super(key: key);

  @override
  State<TargetWeightScreen> createState() => _TargetWeightScreenState();
}

class _TargetWeightScreenState extends ResourcefulState<TargetWeightScreen> {
  late TargetWeightBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = TargetWeightBloc();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      VxNavigator.of(context).push(
        Uri.parse('/$event'),
      );
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

    return Scaffold(
      appBar: Toolbar(titleBar: intl.setGoalWeight),
      body: body(),
    );
  }

  Widget body() {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                shape: AppShapes.rectangleMild,
                elevation: 2,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  child: StreamBuilder<bool>(
                      stream: bloc.loadingContent,
                      builder: (context, loadingContent) {
                        if (loadingContent.hasData &&
                            !loadingContent.requireData) {
                          return StreamBuilder<TargetWeight>(
                              stream: bloc.targetWeightData,
                              builder: (context, targetWeightData) {
                                if (targetWeightData.hasData)
                                  return content(targetWeightData.requireData);
                                return EmptyBox();
                              });
                        }
                        return Center(child: Progress());
                      }),
                ),
              ),
            ),
          ),
          BottomNav(currentTab: BottomNavItem.DIET),
        ],
      ),
    );
  }

  Widget content(TargetWeight targetWeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ImageUtils.fromLocal(
          'assets/images/diet/body-scale-happy.svg',
          width: 40.w,
          // height: 20.w,
        ),
        Space(height: 2.h),
        this.title(targetWeight.bodyStatus!.title!),
        Space(height: 2.h),
        this.description(targetWeight.bodyStatus!.description!),
        Space(height: 2.h),
        buttons(targetWeight),
        Space(height: 1.h),
      ],
    );
  }

  Widget title(String title) {
    return Text(
      title,
      style: typography.caption,
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }

  Widget description(String description) {
    return Text(
      description,
      style: typography.caption!.copyWith(color: Colors.grey),
      softWrap: true,
      textAlign: TextAlign.center,
    );
  }

  Widget buttons(TargetWeight targetWeight) {
    return !targetWeight.askToChangeTargetWeight!
        ? Center(
            child: SubmitButton(
              label: intl.confirmContinue,
              onTap: () => context.vxNav.push(Uri(
                  path:
                      '/${navigator.currentConfiguration!.path.substring(1).split('/').first}/sick/select')),
            ),
          )
        : Column(
            children: [
              Center(
                child: SubmitButton(
                  label: intl.wantToStayAtWeight(targetWeight.weight!.toInt()),
                  onTap: () => bloc.sendVisit(),
                ),
              ),
              Space(height: 2.h),
              Center(
                child: SubmitButton(
                  label: intl.wantToBackAtWeight(targetWeight.targetWeight!.toInt()),
                  onTap: () => context.vxNav.push(Uri(
                      path:
                          '/${navigator.currentConfiguration!.path.substring(1).split('/').first}/sick/select')),
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
