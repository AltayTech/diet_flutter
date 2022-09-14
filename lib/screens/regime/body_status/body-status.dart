import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/bmi_status.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/regime/body_status/bloc.dart';
import 'package:behandam/screens/widget/checkbox.dart';
import 'package:behandam/screens/widget/detail_screen.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/help_dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/widget/custom_button.dart';
import 'package:behandam/widget/custom_player.dart' as cPlayer;
import 'package:behandam/widget/custom_video.dart';
import 'package:behandam/widget/stepper_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class BodyStatusScreen extends StatefulWidget {
  const BodyStatusScreen({Key? key}) : super(key: key);

  @override
  _BodyStatusScreenState createState() => _BodyStatusScreenState();
}

class _BodyStatusScreenState extends ResourcefulState<BodyStatusScreen> {
  late BodyStatusBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BodyStatusBloc();
    bloc.getUserAllowedDietType();
    listenBloc();
  }

  void listenBloc() {
    bloc.navigateToVerify.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      MemoryApp.page++;
      context.vxNav.push(Uri.parse('/${event}'));
    });
    bloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      // Utils.getSnackbarMessage(context, event);
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
      backgroundColor: Colors.white,
      appBar: Toolbar(titleBar: intl.statusReport),
      body: WillPopScope(
          onWillPop: () {
            MemoryApp.page--;
            return Future.value(true);
          },
          child: body()),
    );
  }

  Widget body() {
    return SafeArea(
      child: StreamBuilder(
          stream: bloc.status,
          builder: (context, AsyncSnapshot<BodyStatus> snapshot) {
            if (snapshot.hasData) {
              return TouchMouseScrollable(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Space(height: 1.h),
                      header(),
                      Space(height: 3.h),
                      snapshot.data!.isPregnancy == 1
                          ? showWeightBmi(
                              snapshot.data!.daysTillChildbirth,
                              snapshot.data!.pregnancyWeightDiff!.toStringAsFixed(1),
                              snapshot.data!.pregnancyWeight!.toStringAsFixed(1),
                              snapshot.data!.isPregnancy,
                              getBmiStatus(snapshot.data!.bmiStatus),
                              snapshot.data!.bmi!.toStringAsFixed(0))
                          : showWeightBmi(
                              snapshot.data!.dietDays,
                              snapshot.data!.weightDifference!.toStringAsFixed(1),
                              snapshot.data!.normalWeight!.toStringAsFixed(1),
                              snapshot.data!.isPregnancy,
                              getBmiStatus(snapshot.data!.bmiStatus),
                              snapshot.data!.bmi!.toStringAsFixed(0)),
                      Space(height: 2.h),
                      dietType(),
                      Space(height: 2.h),
                      StreamBuilder<TempTicket>(
                          stream: bloc.template,
                          builder: (context, template) {
                            if (template.hasData) return helpDietSelect(template.requireData);
                            return Progress();
                          }),
                      Space(height: 2.h),
                      Padding(
                        padding: const EdgeInsets.only(right: 32, left: 32),
                        child: CustomButton.withIcon(AppColors.btnColor, intl.nextStage,
                            Size(100.w, 6.h), Icon(Icons.arrow_forward), () {
                          sendRequest(isPregnancy: snapshot.data!.isPregnancy! == 1);
                        }),
                      ),
                      Space(height: 2.h),
                    ],
                  ),
                ),
              );
            } else
              return Center(child: Container(width: 15.w, height: 15.w, child: Progress()));
          }),
    );
  }

  Widget header() {
    return Container(
      padding: EdgeInsets.only(right: 32, left: 32),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Space(height: 1.h),
        Container(
          width: 100.w,
          alignment: Alignment.center,
          child: StepperWidget(),
        ),
        Space(height: 2.h),
        Text(
          intl.statusReport,
          textDirection: context.textDirectionOfLocale,
          style: typography.subtitle1!.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          intl.thisIsFirstStatusReport,
          textDirection: context.textDirectionOfLocale,
          style: typography.caption!.copyWith(fontSize: 10.sp),
        ),
      ]),
    );
  }

  Widget showWeightBmi(int? dietDays, String? weightDiff, String? weight, int? pregnancy,
      BmiStatus? bmiStatus, String? bmi) {
    return Container(
      height: 270,
      padding: EdgeInsets.only(right: 32, left: 32),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (pregnancy == 0)
                          bmiStatus!.status == 0
                              ? colorfulContainer('$weightDiff', bmiStatus, intl.lakeWeight,
                                  intl.kiloGr, '', AppColors.purpleRuler)
                              : colorfulContainer('$weightDiff', bmiStatus, intl.extraWeight,
                                  intl.kiloGr, '', AppColors.purpleRuler),
                        if (pregnancy == 1)
                          colorfulContainer('$weightDiff', bmiStatus!, intl.getWeight, intl.kiloGr,
                              '', AppColors.pregnantPink),
                        Space(height: 1.h),
                        Expanded(
                          child: Container(
                            width: 40.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: AppColors.grey,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(intl.bmi,
                                      style: typography.caption!
                                          .copyWith(color: Colors.grey.withOpacity(0.9))),
                                  Text('BMI',
                                      style: typography.caption!
                                          .copyWith(color: Colors.grey.withOpacity(0.9))),
                                  Expanded(
                                    child: Container(
                                      width: 30.w,
                                      padding: EdgeInsets.only(top: 1.1.h),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: Colors.white),
                                      child: Center(
                                          child: Text(
                                        '$bmi',
                                        textAlign: TextAlign.center,
                                        style: typography.caption!.copyWith(
                                            color: AppColors.redBar,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16.sp),
                                      )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Space(height: 1.h),
                        Expanded(
                          flex: 0,
                          child: InkWell(
                            onTap: () => DialogUtils.showBottomSheetPage(
                                context: context, child: HelpDialog(helpId: 1)),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(color: AppColors.redBar)),
                              child: Container(
                                padding: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('BMI',
                                        style:
                                            typography.caption!.copyWith(color: AppColors.redBar)),
                                    Space(width: 1.w),
                                    Text(intl.what,
                                        style:
                                            typography.caption!.copyWith(color: AppColors.redBar)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Space(width: 3.w),
                Expanded(
                  child: Container(
                    child: ImageUtils.fromLocal(bmiStatus!.imagePath),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget colorfulContainer(
      String weight, BmiStatus bmiStatus, String txt2, String txt3, String txt4, Color color) {
    return Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: bmiStatus.color),
        child: Row(children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(bmiStatus.text,
                      style: typography.caption!.copyWith(fontSize: 10.sp, color: Colors.white)),
                  bmiStatus.status! != 1
                      ? RichText(
                          textDirection: context.textDirectionOfLocale,
                          text: TextSpan(
                            text: weight,
                            style: typography.caption!.copyWith(
                                fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.w700),
                            children: <TextSpan>[
                              TextSpan(
                                  text: ' ',
                                  style: typography.caption!
                                      .copyWith(fontSize: 12.sp, color: Colors.white)),
                              TextSpan(
                                  text: txt3,
                                  style: typography.caption!.copyWith(
                                      fontSize: 12.sp,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700))
                            ],
                          ),
                        )
                      : Container(),
                  if (txt4.length > 0)
                    Text(txt4,
                        style: typography.caption!.copyWith(fontSize: 10.sp, color: Colors.white))
                ],
              ),
            ),
          )
        ]));
  }

  BmiStatus getBmiStatus(int? status) {
    switch (status) {
      case 0:
        return BmiStatus(
            status: status!,
            text: intl.lakeWeight,
            imagePath: 'assets/images/physical_report/thin.svg',
            color: AppColors.weightBoxColorBlue);
      case 1:
        return BmiStatus(
            status: status!,
            text: intl.normal,
            imagePath: 'assets/images/physical_report/normal.svg',
            color: AppColors.weightBoxColorGreen);
      case 2:
        return BmiStatus(
            status: status!,
            text: intl.extraWeight,
            imagePath: 'assets/images/physical_report/fat.svg',
            color: AppColors.weightBoxColorOrange);
      case 3:
        return BmiStatus(
            status: status!,
            text: intl.fatDegree1,
            imagePath: 'assets/images/physical_report/obesity.svg',
            color: AppColors.weightBoxColorRedLight);
      case 4:
        return BmiStatus(
            status: status!,
            text: intl.extraFat,
            imagePath: 'assets/images/physical_report/extreme_obesity.svg',
            color: AppColors.weightBoxColorRed);
      case 5:
        return BmiStatus(
            status: status!,
            text: intl.extraFat,
            imagePath: 'assets/images/physical_report/extreme_obesity.svg',
            color: AppColors.weightBoxColorRed);
      default:
        return BmiStatus(
            status: status!,
            text: intl.extraFat,
            imagePath: 'assets/images/physical_report/extreme_obesity.svg',
            color: AppColors.weightBoxColorRed);
    }
  }

  Widget dietType() {
    return StreamBuilder<List<DietType>>(
        stream: bloc.dietTypeList,
        builder: (context, dietTypeList) {
          return dietTypeList.hasData
              ? Container(
                  margin: EdgeInsets.only(right: 32, left: 32),
                  height: dietTypeList.data!.length > 2 ? 35.h : 25.h,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: AppColors.dietTypeBoxColor, width: 1),
                      boxShadow: [
                        BoxShadow(
                            color: AppColors.priceGreenColor.withOpacity(0.08),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(1, 0))
                      ],
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        top: 2,
                        child: ImageUtils.fromLocal("assets/images/diet/spoon_fork.svg",
                            width: 22.w, height: 22.w, fit: BoxFit.contain),
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Space(
                              height: 3.h,
                            ),
                            Text(
                              intl.dietsSuitableYou,
                              style: typography.caption!.copyWith(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: -1.4,
                                  fontSize: 13.sp),
                            ),
                            Space(
                              height: 3.h,
                            ),
                            StreamBuilder<DietType?>(
                                stream: bloc.dietSelected,
                                builder: (context, dietSelected) {
                                  if (dietTypeList.data!.length > 1) {
                                    return Wrap(
                                      spacing: 5.w,
                                      runSpacing: 3.h,
                                      textDirection: context.textDirectionOfLocale,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      alignment: WrapAlignment.center,
                                      runAlignment: WrapAlignment.start,
                                      children: [
                                        ...dietTypeList.data!
                                            .asMap()
                                            .map((index, value) => MapEntry(
                                                index,
                                                SizedBox(
                                                  width: 35.w,
                                                  child: CheckBoxApp(
                                                      maxHeight: 8.h,
                                                      titleFontSize: 12.sp,
                                                      rowMainAxisAlignment: MainAxisAlignment.start,
                                                      isBorder: true,
                                                      iconSelectType: IconSelectType.Radio,
                                                      onTap: () {
                                                        bloc.setDietSelected =
                                                            dietTypeList.data![index];
                                                      },
                                                      title: dietTypeList.data![index].title!,
                                                      isSelected: dietSelected.data?.id ==
                                                          dietTypeList.data![index].id),
                                                )))
                                            .values
                                            .toList()
                                      ],
                                    );
                                  } else
                                    return RichText(
                                        text: TextSpan(
                                            text: intl.dietSuitableYou,
                                            style: typography.caption!.copyWith(
                                                fontWeight: FontWeight.w400, letterSpacing: -1.5),
                                            children: [
                                          TextSpan(
                                            text: dietTypeList.data![0].title,
                                            style: typography.caption!.copyWith(
                                                fontWeight: FontWeight.w700,
                                                decoration: TextDecoration.underline),
                                          ),
                                          TextSpan(
                                            text: intl.continueDietSuitableYou,
                                            style: typography.caption!
                                                .copyWith(fontWeight: FontWeight.w400),
                                          ),
                                        ]));
                                }),
                          ]),
                    ],
                  ),
                )
              : Container(height: 20.h, child: Progress());
        });
  }

  Widget helpDietSelect(TempTicket helpMedia) {
    return Container(
      width: 100.w,
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.only(right: 32, left: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          ...helpMedia.data!
              .asMap()
              .map((index, value) => MapEntry(
              index,
              templateItemWidget(value)))
              .values
              .toList(),
        ],
      ),
    );
  }

  Widget templateItemWidget(TempItem templateItem) {
    if (templateItem.alterText != null) {
      return Html(
        data: "<div style='direction:rtl'> ${templateItem.alterText} </div>",
        shrinkWrap: true,
        onLinkTap: (url, context, attributes, element) {
          Utils.launchURL(url!);
        },
      );
    } else {
      if (templateItem.media!.isNotEmpty && templateItem.media![0].mediumType == MediumType.file) {
        templateItem.media![0].progress = false;
        String? name = templateItem.media![0].fileName;
      }
      MediumType? mediumType = templateItem.media![0].mediumType;
      switch (mediumType) {
        case MediumType.IMAGE:
          return GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) {
              return DetailScreen(templateItem.media![0].mediumUrls!.url);
            })),
            child: Container(
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  templateItem.media![0].mediumUrls!.url!,
                  fit: BoxFit.fill,
                  loadingBuilder:
                      (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: AppColors.accentColor,
                        valueColor: new AlwaysStoppedAnimation<Color>(AppColors.primary),
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        case MediumType.VIDEO:
          return Container(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CustomVideo(
                image: null,
                isLooping: false,
                isStart: false,
                url: templateItem.media![0].mediumUrls!.url,
              ),
            ),
          );
        case MediumType.AUDIO:
          return Container(
            width: double.maxFinite,
            padding: EdgeInsets.only(left: 8, right: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.black12,
            ),
            child: cPlayer.CustomPlayer(
              isAdmin: false,
              media: cPlayer.Media.remoteExampleFile,
              url: templateItem.media![0].mediumUrls!.url,
            ),
          );
        default:
          return Container();
      }
    }
  }

  void pregnancyWeekAlert() {
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
                '',
                style: typography.bodyText2,
                textAlign: TextAlign.center,
              ),
              Space(height: 2.h),
              Text(
                intl.pregnancyWeekAlertDesc(bloc.bodyStatus.allowedWeeksNum!),
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
                    bloc.nextStep();
                  },
                  label: intl.understandGoToNext,
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

  void sendRequest({required bool isPregnancy}) {
    if (isPregnancy) {
      pregnancyWeekAlert();
    } else {
      if (!MemoryApp.isShowDialog) DialogUtils.showDialogProgress(context: context);
      if (bloc.getDietSelected != null)
        bloc.updateDietType();
      else
        Utils.getSnackbarMessage(context, intl.pleaseSelectDietType);
    }
  }

  @override
  void onRetryAfterNoInternet() {
    sendRequest(isPregnancy: false);
  }

  @override
  void onRetryLoadingPage() {
    bloc.getUserAllowedDietType();
  }
}
