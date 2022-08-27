import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:behandam/screens/regime/sickness/sicknss_provider.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/custom_switch.dart';
import 'package:behandam/widget/sickness_dialog.dart';
import 'package:behandam/widget/stepper_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class SicknessScreen extends StatefulWidget {
  const SicknessScreen({Key? key}) : super(key: key);

  @override
  _SicknessScreenState createState() => _SicknessScreenState();
}

class _SicknessScreenState extends ResourcefulState<SicknessScreen> implements ItemClick {
  late SicknessBloc sicknessBloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    sicknessBloc = SicknessBloc();
    sicknessBloc.getSickness();
    listenBloc();
  }

  void listenBloc() {
    sicknessBloc.navigateTo.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      VxNavigator.of(context).push(Uri.parse(event));
    });
    sicknessBloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, event);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SicknessProvider(sicknessBloc,
        child: Scaffold(
          appBar: Toolbar(titleBar: intl.sickness),
          body: WillPopScope(
              onWillPop: () {
                MemoryApp.page--;
                return Future.value(true);
              },child: body()),
        ));
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(4.w),
          color: Colors.white,
          child: StreamBuilder(
              stream: sicknessBloc.waiting,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data == false) {
                  controller.text = sicknessBloc.userSickness?.sicknessNote ?? '';
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
        Space(height: 1.h),
        Container(
          width: 100.w,
          alignment: Alignment.center,
          child: StepperWidget(),
        ),
        Container(
          child: Padding(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  intl.obstructiveDisease,
                  textAlign: TextAlign.start,
                  style: typography.subtitle1!.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  intl.obstructiveCauseToLeaveDiet,
                  textAlign: TextAlign.start,
                  style: typography.caption!.copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
                ),
                Space(height: 2.h),
                if (sicknessBloc.userSickness != null)
                  StreamBuilder<List<CategorySickness>>(
                      stream: sicknessBloc.userCategorySickness,
                      builder: (context, userCategorySickness) {
                        if (userCategorySickness.hasData &&
                            userCategorySickness.requireData.length > 0)
                          return ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: sicknessBloc.userSickness!.sickness_categories!.length,
                              itemBuilder: (BuildContext context, int index) => sicknessBox(
                                    index,
                                    sicknessBloc.userSickness!.sickness_categories![index],
                                  ));
                        else if (sicknessBloc.userSickness!.sickness_categories!.length <= 0)
                          return Container(
                              child: Text(intl.emptySickness, style: typography.caption));
                        else
                          return Container(height: 80.h, child: Progress());
                      }),
                Space(height: 1.h),
                Padding(
                  padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                  child: CustomButton.withIcon(AppColors.btnColor, intl.nextStage, Size(100.w, 6.h),
                      Icon(Icons.arrow_forward), () {}),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget sicknessBox(int index, CategorySickness sickness) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: sickness.isSelected!),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: Container(
            padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
            ),
            child: sickness.sicknesses!.length > 0
                ? ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: sickness.sicknesses!.length,
                    itemBuilder: (BuildContext context, int index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CheckBoxApp.description(
                              contentPadding: 8,
                              isBorder: false,
                              iconSelectType: IconSelectType.Checked,
                              onTap: () {
                                sickness.sicknesses![index].isSelected =
                                    !sickness.sicknesses![index].isSelected!;
                                setState(() {});
                              },
                              title: sickness.sicknesses![index].title!,
                              isSelected: sickness.sicknesses![index].isSelected!,
                              description: 'توضیح درباره اینکه چرا با این عارضه نمیشه رژیم گرفت'),
                        ))
                : Container()),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: sickness.isSelected!
                  ? BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                  : BorderRadius.circular(10),
            ),
            child: Column(children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(child: Text(sickness.title!, style: typography.caption)),
                  Expanded(
                    child: CustomSwitch(
                      isSwitch: sickness.isSelected!,
                      title: '',
                      lableLeft: intl.iHave,
                      lableRight: intl.iDoNotHave,
                      colorSelected: AppColors.priceGreenColor,
                      colorOff: AppColors.grey,
                      function: (value) {
                        sickness.isSelected = !sickness.isSelected!;
                        sicknessBloc.updateSickness(index, sickness);
                      },
                    ),
                  )
                ],
              ),
            ])),
        collapsed: Container(),
      ),
    );
  }

  void sendRequest() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    sicknessBloc.sendSickness();
  }

  @override
  void onRetryAfterNoInternet() {
    sendRequest();
  }

  @override
  void onRetryLoadingPage() {
    sicknessBloc.getSickness();
  }

  @override
  click() {
    setState(() {});
  }

  @override
  void dispose() {
    sicknessBloc.dispose();
    controller.dispose();
    super.dispose();
  }
}
