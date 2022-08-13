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
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/bottom_triangle.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/custom_switch.dart';
import 'package:behandam/widget/sickness_dialog.dart';
import 'package:behandam/widget/stepper.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherSicknessScreen extends StatefulWidget {
  const OtherSicknessScreen({Key? key}) : super(key: key);

  @override
  _OtherSicknessScreenState createState() => _OtherSicknessScreenState();
}

class _OtherSicknessScreenState extends ResourcefulState<OtherSicknessScreen>
    implements ItemClick {
  late SicknessBloc sicknessBloc;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    sicknessBloc = SicknessBloc();
    sicknessBloc.getNotBlockingSickness();
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
          appBar: Toolbar(titleBar: intl.otherSickness),
          body: body(),
        ));
  }

  Widget body() {
    return TouchMouseScrollable(
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 3.h),
          color: Colors.white,
          child: StreamBuilder(
              stream: sicknessBloc.waiting,
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
              /*if (sicknessBloc.userSickness != null)*/
                StreamBuilder<List<CategorySickness>>(
                    stream: sicknessBloc.userCategorySickness,
                    builder: (context, userCategorySickness) {
                      if (userCategorySickness.hasData &&
                          userCategorySickness.requireData.length > 0)
                        return ListView.builder(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: sicknessBloc
                                .userSickness!.sickness_categories!.length,
                            itemBuilder: (BuildContext context, int index) =>
                                sicknessBox(
                                  index,
                                  sicknessBloc.userSickness!
                                      .sickness_categories![index],
                                ));
                      else if (sicknessBloc
                              .userSickness!.sickness_categories!.length <=
                          0)
                        return Container(
                            child: Text(intl.emptySickness,
                                style: typography.caption));
                      else
                        return Container(height: 80.h, child: Progress());
                    }),
              Space(height: 1.h),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, left: 16.0),
                child: CustomButton.withIcon(AppColors.btnColor, intl.nextStage,
                    Size(100.w, 6.h), Icon(Icons.arrow_forward), () {}),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget sicknessBox(int index, CategorySickness sickness) {
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
            child: sickness.sicknesses!.length > 0
                ? Wrap(
                    children: <Widget>[
                      ...sickness.sicknesses!
                          .map((sickness) => sicknessItem(sickness))
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
                  Expanded(
                      child: Text(sickness.title!, style: typography.caption)),
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

  Widget sicknessItem(CategorySickness sickness) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Flexible(
        child: CheckBoxApp(
          isBorder: false,
          iconSelectType: IconSelectType.Radio,
          onTap: () {
            sickness.isSelected = !sickness.isSelected!;
            setState(() {});
          },
          title: sickness.title!,
          isSelected: sickness.isSelected!,
        ),
      ),
    );
  }

  void sendRequest() {
    if (!MemoryApp.isShowDialog)
      DialogUtils.showDialogProgress(context: context);
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
