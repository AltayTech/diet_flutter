import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/sickness/other_sickness/bloc.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/sickness_dialog.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../../data/entity/regime/obstructive_disease.dart';

class OtherSicknessScreen extends StatefulWidget {
  const OtherSicknessScreen({Key? key}) : super(key: key);

  @override
  _OtherSicknessScreenState createState() => _OtherSicknessScreenState();
}

class _OtherSicknessScreenState extends ResourcefulState<OtherSicknessScreen> {
  late OtherSicknessBloc bloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloc = OtherSicknessBloc();
    bloc.getNotBlockingSickness();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateTo.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      VxNavigator.of(context).push(Uri.parse(event));
    });
    bloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.otherSickness),
      body: body(),
    );
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
          color: Colors.white,
          child: StreamBuilder(
              stream: bloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == false) {
                  /*controller.text =
                      sicknessBloc.userSickness?.sicknessNote ?? '';*/
                  return content();
                } else {
                  return Container(height: 80.h, child: Progress());
                }
              }),
        ),
      ),
    );
  }

  Widget content() {
    return Column(
      children: [
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                intl.otherSickness,
                textAlign: TextAlign.start,
                style: typography.subtitle1!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                intl.youMustEnterCorrectInfoOfBodyState,
                textAlign: TextAlign.start,
                style: typography.caption!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Text(
                intl.thisInfoVeryImportantToReduceYourWeight,
                textAlign: TextAlign.start,
                style: typography.caption!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
              ),
              Space(height: 2.h),
              StreamBuilder<List<ObstructiveDisease>>(
                  stream: bloc.userSickness,
                  builder: (context, userSickness) {
                    if (userSickness.hasData) {
                      if (userSickness.requireData.length > 0) {
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: userSickness.requireData.length,
                            itemBuilder: (BuildContext context, int index) =>
                                sicknessBox(
                                  userSickness.requireData[index].title!,
                                  index,
                                  userSickness.requireData[index].categories!,
                                ));
                      } else {
                        return Container(
                            child: Text(intl.emptySickness,
                                style: typography.caption));
                      }
                    } else {
                      return Container(height: 60.h, child: Progress());
                    }
                  }),
              Space(height: 1.h),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: CustomButton.withIcon(AppColors.btnColor, intl.nextStage,
                    Size(100.w, 6.h), Icon(Icons.arrow_forward), () {
                  sendRequest();
                }),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget sicknessBox(
      String title, int index, List<ObstructiveDiseaseCategory> sickness) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: true),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            child: sickness.length > 0
                ? Wrap(
                    children: [
                      ...sickness
                          .mapIndexed(
                              (sickness, i) => sicknessItem(index, i, sickness))
                          .toList(),
                    ],
                  )
                : Container()),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.15),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(title, style: typography.caption)),
                ],
              ),
              Space(height: 2.h),
              Container(
                height: 1.5,
                color: Colors.grey.withOpacity(0.2),
              )
            ])),
        collapsed: Container(),
      ),
    );
  }

  Widget sicknessItem(int indexSickness, int indexCategory,
      ObstructiveDiseaseCategory sickness) {
    return InkWell(
      onTap: () {
        sickness.isSelected = !sickness.isSelected!;
        bloc.updateSickness(indexSickness, indexCategory, sickness);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Chip(
            label: Text(sickness.title!,
                style: typography.caption!
                    .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp))),
      ),
    );
  }

  void sendRequest() {
    if (!MemoryApp.isShowDialog)
      DialogUtils.showDialogProgress(context: context);
    bloc.sendSickness();
  }

  @override
  void onRetryAfterNoInternet() {
    sendRequest();
  }

  @override
  void onRetryLoadingPage() {
    bloc.getNotBlockingSickness();
  }

  @override
  void dispose() {
    bloc.dispose();
    controller.dispose();
    super.dispose();
  }
}
