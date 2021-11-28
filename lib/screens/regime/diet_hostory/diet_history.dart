import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/screens/regime/diet_hostory/bloc.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:velocity_x/src/extensions/context_ext.dart';

class DietHistoryPage extends StatefulWidget {
  const DietHistoryPage({Key? key}) : super(key: key);

  @override
  _DietHistoryPageState createState() => _DietHistoryPageState();
}

class _DietHistoryPageState extends ResourcefulState<DietHistoryPage> {
  late DietHistoryBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = DietHistoryBloc();
    bloc.navigateTo.listen((event) {
      Navigator.of(context).pop();
      context.vxNav.push(Uri.parse('/$event'));
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
      appBar: Toolbar(titleBar: intl.dietHistory),
      body: SingleChildScrollView(
        child: Card(
          shape: AppShapes.rectangleMedium,
          elevation: 1,
          margin: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
            child: StreamBuilder(
              stream: bloc.dietHistory,
              builder: (_, AsyncSnapshot<DietHistoryData> snapshot) {
                if (snapshot.hasData)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        intl.haveYouEverBeenOnDiet,
                        style: typography.caption,
                        textAlign: TextAlign.center,
                      ),
                      Space(height: 2.h),
                      ...snapshot.requireData.items
                          .map((history) => item(history))
                          .toList(),
                      Center(
                        child: SubmitButton(
                            label: intl.nextStage,
                            onTap: () {
                              DialogUtils.showDialogProgress(context: context);
                              bloc.condition();
                            }),
                      ),
                    ],
                  );
                return Center(child: Progress());
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget item(DietHistory history) {
    return StreamBuilder(
      stream: bloc.selectedDietHistory,
      builder: (_, AsyncSnapshot<DietHistory?> snapshot) {
        return GestureDetector(
          onTap: () => bloc.onDietHistoryClick(history),
          child: Container(
            decoration: AppDecorations.boxMedium.copyWith(
              color: AppColors.greenRuler,
              boxShadow:
                  snapshot.hasData && snapshot.requireData!.id == history.id
                      ? [
                          BoxShadow(
                            color: AppColors.greenRuler,
                            blurRadius: 6.0,
                            spreadRadius: 1.0,
                          ),
                        ]
                      : null,
            ),
            margin: EdgeInsets.only(bottom: 2.h),
            child: Container(
              margin: EdgeInsets.only(right: 3.w),
              decoration: BoxDecoration(
                color:
                    snapshot.hasData && snapshot.requireData!.id == history.id
                        ? AppColors.onPrimary
                        : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: AppRadius.radiusMedium,
                  topLeft: AppRadius.radiusMedium,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 3.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    history.title,
                    style: typography.subtitle2,
                    textAlign: TextAlign.start,
                  ),
                  Text(
                    history.description ?? '',
                    style: typography.caption?.apply(
                      color: AppColors.labelColor,
                    ),
                    textAlign: TextAlign.start,
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
        );
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
