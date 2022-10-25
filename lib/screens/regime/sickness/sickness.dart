import 'package:behandam/app/app.dart';
import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/obstructive_disease.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/sickness/sickness_bloc.dart';
import 'package:behandam/screens/regime/sickness/sicknss_provider.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/custom_switch.dart';
import 'package:behandam/widget/sickness_dialog.dart';
import 'package:behandam/widget/stepper_widget.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:logifan/extensions/bool.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../utils/image.dart';

class SicknessScreen extends StatefulWidget {
  const SicknessScreen({Key? key}) : super(key: key);

  @override
  _SicknessScreenState createState() => _SicknessScreenState();
}

class _SicknessScreenState extends ResourcefulState<SicknessScreen> implements ItemClick {
  late SicknessBloc sicknessBloc;
  TextEditingController controller = TextEditingController();
  bool isShowStepper = true;

  @override
  void initState() {
    super.initState();
    sicknessBloc = SicknessBloc();
    sicknessBloc.getSickness();
    if (navigator.currentConfiguration!.path.contains('list')) {
      isShowStepper = false;
    }
    listenBloc();
  }

  void listenBloc() {
    sicknessBloc.navigateTo.listen((event) {
      MemoryApp.isShowDialog = false;
      if (!event.toString().contains('block')) MemoryApp.page++;
      VxNavigator.of(context).push(Uri.parse(event));
    });

    sicknessBloc.popDialog.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SicknessProvider(sicknessBloc,
        child: Scaffold(
          appBar: Toolbar(
            titleBar: intl.sickness,
          ),
          body: WillPopScope(
              onWillPop: () {
                MemoryApp.page--;
                return Future.value(true);
              },
              child: body()),
        ));
  }

  Widget body() {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(4.w),
      color: Colors.white,
      child: StreamBuilder(
          stream: sicknessBloc.waiting,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == false) {
              //controller.text = sicknessBloc.userCategoryDisease?.sicknessNote ?? '';
              return content();
            } else {
              return Container(height: 80.h, child: Progress());
            }
          }),
    );
  }

  Widget content() {
    return Column(
      children: [
        Expanded(
          child: TouchMouseScrollable(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Space(height: 1.h),
                  if (isShowStepper)
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
                            style: typography.caption!
                                .copyWith(fontWeight: FontWeight.w400, fontSize: 10.sp),
                          ),
                          Space(height: 2.h),
                          if (sicknessBloc.userCategoryDisease != null)
                            StreamBuilder<List<ObstructiveDiseaseCategory>>(
                                stream: sicknessBloc.userCategoryDisease,
                                builder: (context, userCategoryDisease) {
                                  if (userCategoryDisease.data != null &&
                                      userCategoryDisease.hasData &&
                                      userCategoryDisease.requireData.length > 0)
                                    return ListView.builder(
                                        physics: ClampingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: userCategoryDisease.requireData.length,
                                        itemBuilder: (BuildContext context, int index) =>
                                            sicknessBox(
                                              index,
                                              userCategoryDisease.requireData[index],
                                            ));
                                  else if (userCategoryDisease.data != null &&
                                      userCategoryDisease.requireData.length <= 0)
                                    return Container(
                                        child: Text(intl.emptySickness, style: typography.caption));
                                  else
                                    return Container(height: 80.h, child: Progress());
                                }),
                          Space(height: 1.h),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: CustomButton.withIcon(
              AppColors.btnColor, intl.nextStage, Size(100.w, 6.h), Icon(Icons.arrow_forward), () {
            sendRequest();
          }),
        ),
        Space(height: 2.h),
      ],
    );
  }

  Widget sicknessBox(int index, ObstructiveDiseaseCategory sickness) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: ExpandablePanel(
        controller: ExpandableController(initialExpanded: sickness.isSelected!),
        theme: ExpandableThemeData(
            expandIcon: null,
            collapseIcon: null,
            hasIcon: false,
            animationDuration: const Duration(milliseconds: 700)),
        expanded: sickness.isSelected!
            ? Container(
                padding: EdgeInsets.only(bottom: 8, right: 8, left: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.15),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10), bottomRight: Radius.circular(10)),
                ),
                child: sickness.diseases!.length > 0
                    ? ListView.builder(
                        physics: ClampingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: sickness.diseases!.length,
                        itemBuilder: (BuildContext context, int index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CheckBoxApp.description(
                                  contentPadding: 8,
                                  isBorder: false,
                                  iconSelectType: sickness.hasMultiChoiceChildren.isNotNullAndTrue
                                      ? IconSelectType.Checked
                                      : IconSelectType.Radio,
                                  onTap: () {
                                    if (sickness.hasMultiChoiceChildren.isNotNullAndTrue)
                                      sickness.diseases![index].isSelected =
                                          !sickness.diseases![index].isSelected!;
                                    else {
                                      sickness.diseases!.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      sickness.diseases![index].isSelected =
                                          !sickness.diseases![index].isSelected!;
                                    }
                                    setState(() {});
                                  },
                                  title: sickness.diseases![index].title!,
                                  isSelected: sickness.diseases![index].isSelected!,
                                  description: sickness.diseases![index].description ?? ""),
                            ))
                    : EmptyBox())
            : EmptyBox(),
        header: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.15),
              borderRadius: sickness.isSelected!
                  ? BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))
                  : BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(flex: 1, child: Text(sickness.title!, style: typography.caption)),
                Expanded(
                  flex: 1,
                  child: CustomSwitch(
                    isSwitch: sickness.isSelected!,
                    title: '',
                    lableLeft: sickness.hasMultiChoiceChildren! ? intl.iHave : intl.iAm,
                    lableRight: sickness.hasMultiChoiceChildren! ? intl.iDoNotHave : intl.iAmNot,
                    colorSelected: AppColors.priceGreenColor,
                    colorOff: AppColors.grey,
                    function: (value) {
                      sickness.isSelected = !sickness.isSelected!;
                      sicknessBloc.updateSickness(index, sickness);
                    },
                  ),
                )
              ],
            )),
        collapsed: Container(),
      ),
    );
  }

  void sendRequest() {
    bool isFindOneSingleChoiceCategory = false;
    bool isChoiceElement = false;
    String categoryName = '';
    sicknessBloc.userCategoryDiseaseValue.forEach((category) {
      isFindOneSingleChoiceCategory = false;
      if (category.isSelected! && category.hasMultiChoiceChildren.isNotNullAndFalse) {
        isFindOneSingleChoiceCategory = true;
        isChoiceElement = false;
        category.diseases?.forEach((element) {
          if (element.isSelected.isNotNullAndTrue) {
            isChoiceElement = true;
            return;
          } else {
            categoryName = category.title!;
          }
        });
      }
    });

    if (isFindOneSingleChoiceCategory && !isChoiceElement) {
      Utils.getSnackbarMessage(context, intl.alertDiseaseMessage(categoryName));
      return;
    }
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
    sicknessBloc.sendSickness();
  }

  @override
  void onRetryAfterNoInternet() {
    if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);

    sicknessBloc.setRepository();
    sendRequest();
  }

  @override
  void onRetryLoadingPage() {
    sicknessBloc.setRepository();
    sicknessBloc.getSickness();
  }

  @override
  click() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    sicknessBloc.dispose();
    controller.dispose();
  }
}
