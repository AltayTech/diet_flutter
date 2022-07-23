import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/utils/image.dart';
import 'package:behandam/utils/svg.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

import '../../themes/colors.dart';

class EmojiBox extends StatefulWidget {
  late PollPhrases isContactedToMe;

  EmojiBox(
      {required this.isContactedToMe});

  @override
  _EmojiBoxState createState() => _EmojiBoxState();
}

class _EmojiBoxState extends ResourcefulState<EmojiBox> {
  late SurveyCallSupportBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = SurveyCallSupportProvider.of(context);

    return selectEmojiContainer(this.widget.isContactedToMe);
  }
  Widget selectEmojiContainer(PollPhrases isContactedToMe) {
    return Container(
        width: 80.w,
        margin: EdgeInsets.only(top: 2.h, left: 2.w, right: 2.w),
        padding: EdgeInsets.only(left: 2.w, right: 2.w, top: 1.h, bottom: 1.h),
        decoration: BoxDecoration(
          color: AppColors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: (isContactedToMe.isActive! == boolean.False)
            ? StreamBuilder<List<SurveyRates>>(
            stream: bloc.surveyRates,
            builder: (context, surveyRates) {
              if (surveyRates.hasData)
                return selectEmojiBox(surveyRates.requireData);
              else
                return Center(child: Progress());
            })
            : selectEmojiBoxDisabled());
  }

  Widget selectEmojiBoxDisabled() {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          showEmojiFromString(
              true, EmojiSelected.EXTRA_UPSET, Svg.extraUpsetEmoji, '#DD5F70', '#717171'),
          showEmojiFromString(true, EmojiSelected.UPSET, Svg.upsetEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(true, EmojiSelected.NEUTRAL, Svg.neutralEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(true, EmojiSelected.HAPPY, Svg.happyEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(
              true, EmojiSelected.EXTRA_HAPPY, Svg.extraHappyEmoji, '#EBB34D', '#717171')
        ]),
        Container(
            width: 60.w,
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(intl.surveyCallSupportEmojiTextRate1,
                textAlign: TextAlign.center,
                style: typography.caption!.copyWith(
                    fontWeight: FontWeight.bold, color: AppColors.greyDate.withOpacity(0.1)))),
      ],
    );
  }

  Widget selectEmojiBox(List<SurveyRates> surveyRates) {
    return StreamBuilder<EmojiSelected>(
        initialData: EmojiSelected.EXTRA_HAPPY,
        stream: bloc.emojiSelected,
        builder: (context, emojiSelected) {
          return Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                emojiSelected.requireData == EmojiSelected.EXTRA_UPSET
                    ? showEmojiSelected('assets/images/emoji/pouting_face.svg')
                    : showEmojiFromString(false, EmojiSelected.EXTRA_UPSET, Svg.extraUpsetEmoji,
                    '#DD5F70', '#717171'),
                emojiSelected.requireData == EmojiSelected.UPSET
                    ? showEmojiSelected('assets/images/emoji/face_with_cold_sweat.svg')
                    : showEmojiFromString(
                    false, EmojiSelected.UPSET, Svg.upsetEmoji, '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.NEUTRAL
                    ? showEmojiSelected('assets/images/emoji/neutral_face.svg')
                    : showEmojiFromString(
                    false, EmojiSelected.NEUTRAL, Svg.neutralEmoji, '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.HAPPY
                    ? showEmojiSelected('assets/images/emoji/white_smiling_face.svg')
                    : showEmojiFromString(
                    false, EmojiSelected.HAPPY, Svg.happyEmoji, '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.EXTRA_HAPPY
                    ? showEmojiSelected('assets/images/emoji/smiling_face_with_open_mouth.svg')
                    : showEmojiFromString(
                    false, EmojiSelected.EXTRA_HAPPY, Svg.extraHappyEmoji, '#EBB34D', '#717171')
              ]),
              Container(
                  width: 60.w,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redBar.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: showEmojiSelectedText(emojiSelected.requireData, surveyRates)),
            ],
          );
        });
  }

  Widget showEmojiSelectedText(EmojiSelected emojiSelected, List<SurveyRates> surveyRates) {
    switch (emojiSelected) {
      case EmojiSelected.EXTRA_UPSET:
        return Text(surveyRates[0].title ?? intl.surveyCallSupportEmojiTextRate1,
            textAlign: TextAlign.center,
            style:
            typography.caption!.copyWith(fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.UPSET:
        return Text(surveyRates[1].title ?? intl.surveyCallSupportEmojiTextRate2,
            textAlign: TextAlign.center,
            style:
            typography.caption!.copyWith(fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.NEUTRAL:
        return Text(surveyRates[2].title ?? intl.surveyCallSupportEmojiTextRate3,
            textAlign: TextAlign.center,
            style:
            typography.caption!.copyWith(fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.HAPPY:
        return Text(surveyRates[3].title ?? intl.surveyCallSupportEmojiTextRate4,
            textAlign: TextAlign.center,
            style:
            typography.caption!.copyWith(fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.EXTRA_HAPPY:
        return Text(surveyRates[4].title ?? intl.surveyCallSupportEmojiTextRate5,
            textAlign: TextAlign.center,
            style:
            typography.caption!.copyWith(fontWeight: FontWeight.bold, color: AppColors.redBar));
    }
  }

  Widget showEmojiSelected(String iconPath) {
    return InkWell(
      child: Container(
        width: 12.w,
        height: 6.h,
        decoration: BoxDecoration(
          color: AppColors.redBar.withOpacity(0.1),
          borderRadius: BorderRadius.circular(100),
        ),
        child: showEmojiFromPath(iconPath),
      ),
    );
  }

  Widget showEmojiFromPath(String path) {
    return ImageUtils.fromLocal(path, width: 9.w, height: 9.w, margin: EdgeInsets.all(8));
  }

  Widget showEmojiFromString(bool isDisable, EmojiSelected emojiSelected, String stringSvg,
      String colorPatternFrom, String colorPatternReplace) {
    return InkWell(
      onTap: () {
        if (!isDisable) {
          if (emojiSelected == EmojiSelected.EXTRA_UPSET || emojiSelected == EmojiSelected.UPSET) {
            bloc.tabController!.animateTo(0);
          } else if (emojiSelected == EmojiSelected.EXTRA_HAPPY ||
              emojiSelected == EmojiSelected.HAPPY) {
            bloc.tabController!.animateTo(1);
          } else {
            // when emoji is normal
            bloc.tabController!.animateTo(0);
          }
          bloc.setEmojiSelected = emojiSelected;
          debugPrint("EmojiSelected ${emojiSelected}");
        }
      },
      child: ImageUtils.fromString(
          stringSvg
              .replaceAll(colorPatternFrom, colorPatternReplace)
          // blue sweat
              .replaceAll('#77AAF2', colorPatternReplace)
          // red lips
              .replaceAll('#5B0600', '#000000'),
          width: 9.w,
          height: 9.w,
          margin: EdgeInsets.all(8)),
    );
  }
}
