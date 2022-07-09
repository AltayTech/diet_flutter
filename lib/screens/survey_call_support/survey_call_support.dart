import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_view/food_list.dart' as foodList;
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/subscription/history_subscription_payment/list_history_subscription_payment.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/survey_call_support/strengths_weakness_tabs.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class SurveyCallSupportScreen extends StatefulWidget {
  const SurveyCallSupportScreen({Key? key}) : super(key: key);

  @override
  _SurveyCallSupportScreenState createState() =>
      _SurveyCallSupportScreenState();
}

class _SurveyCallSupportScreenState
    extends ResourcefulState<SurveyCallSupportScreen> {
  late SurveyCallSupportBloc bloc;
  late foodList.SurveyData surveyData;
  bool isInitial = false;

  // EXTRA_UPSET
  String extraUpsetEmoji =
      """<svg width="37" height="37" viewBox="0 0 37 37" fill="#DD5F70" xmlns="http://www.w3.org/2000/svg">
  <path d="M18.7709 36.4684C28.6551 36.4684 36.6677 28.4557 36.6677 18.5716C36.6677 8.68747 28.6551 0.674805 18.7709 0.674805C8.88681 0.674805 0.874146 8.68747 0.874146 18.5716C0.874146 28.4557 8.88681 36.4684 18.7709 36.4684Z" fill="#DD5F70"/>
  <path d="M18.7709 36.4684C28.6551 36.4684 36.6677 28.4557 36.6677 18.5716C36.6677 8.68747 28.6551 0.674805 18.7709 0.674805C8.88681 0.674805 0.874146 8.68747 0.874146 18.5716C0.874146 28.4557 8.88681 36.4684 18.7709 36.4684Z" fill="#DD5F70"/>
  <path d="M14.8722 29.748C14.8722 29.748 18.1397 27.0004 22.6695 29.748" stroke="#5B0600" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M12.0503 23.8071C12.9936 23.8071 13.7583 22.5603 13.7583 21.0223C13.7583 19.4843 12.9936 18.2375 12.0503 18.2375C11.107 18.2375 10.3423 19.4843 10.3423 21.0223C10.3423 22.5603 11.107 23.8071 12.0503 23.8071Z" fill="black"/>
  <path d="M9.93384 14.0496L14.2781 17.0571" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
  <path d="M25.4915 23.8071C26.4348 23.8071 27.1995 22.5603 27.1995 21.0223C27.1995 19.4843 26.4348 18.2375 25.4915 18.2375C24.5482 18.2375 23.7835 19.4843 23.7835 21.0223C23.7835 22.5603 24.5482 23.8071 25.4915 23.8071Z" fill="black"/>
  <path d="M27.1252 14.0496L22.7809 17.0571" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
  </svg>""";

  // UPSET
  String upsetEmoji =
      """<svg width="36" height="38" viewBox="0 0 36 38" fill="#EBB34D" xmlns="http://www.w3.org/2000/svg">
<path d="M17.9368 37.0253C27.8209 37.0253 35.8336 29.0126 35.8336 19.1285C35.8336 9.24435 27.8209 1.23169 17.9368 1.23169C8.0527 1.23169 0.0400391 9.24435 0.0400391 19.1285C0.0400391 29.0126 8.0527 37.0253 17.9368 37.0253Z" fill="#EBB34D"/>
<path d="M21.8726 19.4998C21.8726 19.4998 22.3182 21.2449 24.5089 21.2449C26.5882 21.2449 27.1451 19.4998 27.1451 19.4998" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M8.69141 19.4998C8.69141 19.4998 9.13697 21.2449 11.3277 21.2449C13.4069 21.2449 13.9639 19.4998 13.9639 19.4998" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M14.0381 29.1909C14.0381 29.1909 17.3056 26.4433 21.8355 29.1909" stroke="#5B0600" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M5.72096 0.414877C5.72096 0.414877 9.09981 5.61311 10.0652 8.36075C10.9935 11.0341 10.3622 13.9674 7.83738 15.267C5.31252 16.5665 2.23071 15.564 0.931149 13.0392C0.151413 11.5168 0.337064 9.84596 0.931149 8.36075C2.3421 4.79625 5.27539 0.414877 5.27539 0.414877C5.34965 0.266356 5.49818 0.229228 5.6467 0.303488C5.6467 0.340618 5.68383 0.377747 5.72096 0.414877Z" fill="#77AAF2"/>
</svg>""";

  // NEUTRAL
  String neutralEmoji =
      """<svg width="37" height="36" viewBox="0 0 37 36" fill="#EBB34D" xmlns="http://www.w3.org/2000/svg">
<path d="M18.756 35.9117C28.6402 35.9117 36.6528 27.8991 36.6528 18.0149C36.6528 8.13083 28.6402 0.118164 18.756 0.118164C8.87192 0.118164 0.859253 8.13083 0.859253 18.0149C0.859253 27.8991 8.87192 35.9117 18.756 35.9117Z" fill="#EBB34D"/>
<path d="M11.8127 14.5991C12.756 14.5991 13.5207 13.3523 13.5207 11.8143C13.5207 10.2763 12.756 9.02954 11.8127 9.02954C10.8694 9.02954 10.1047 10.2763 10.1047 11.8143C10.1047 13.3523 10.8694 14.5991 11.8127 14.5991Z" fill="black"/>
<path d="M25.2538 14.5991C26.1971 14.5991 26.9618 13.3523 26.9618 11.8143C26.9618 10.2763 26.1971 9.02954 25.2538 9.02954C24.3105 9.02954 23.5458 10.2763 23.5458 11.8143C23.5458 13.3523 24.3105 14.5991 25.2538 14.5991Z" fill="black"/>
<path d="M14.3375 23.1763C14.3375 23.1763 15.0059 23.1763 18.7189 23.1763C22.4319 23.1763 23.1745 23.1763 23.1745 23.1763" stroke="#5B0600" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""";

  // HAPPY
  String happyEmoji = """
  <svg width="37" height="36" viewBox="0 0 37 36" fill="#EBB34D" xmlns="http://www.w3.org/2000/svg">
<path d="M18.756 35.9117C28.6402 35.9117 36.6528 27.8991 36.6528 18.015C36.6528 8.13083 28.6402 0.118164 18.756 0.118164C8.87192 0.118164 0.859253 8.13083 0.859253 18.015C0.859253 27.8991 8.87192 35.9117 18.756 35.9117Z" fill="#EBB34D"/>
<path d="M14.2633 13.0025C14.2633 13.0025 13.8177 11.2573 11.627 11.2573C9.54773 11.2573 8.99078 13.0025 8.99078 13.0025" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M27.4445 13.0025C27.4445 13.0025 26.9989 11.2573 24.8082 11.2573C22.7289 11.2573 22.172 13.0025 22.172 13.0025" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M13.5207 21.2454C13.5207 21.2454 18.3105 24.2158 23.3231 21.2454" stroke="#5B0600" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""";

  // EXTRA_HAPPY
  String extraHappyEmoji =
      """<svg width="36" height="36" viewBox="0 0 36 36" fill="#EBB34D" xmlns="http://www.w3.org/2000/svg">
<path d="M17.8968 35.9117C27.7809 35.9117 35.7936 27.8991 35.7936 18.015C35.7936 8.13083 27.7809 0.118164 17.8968 0.118164C8.01266 0.118164 0 8.13083 0 18.015C0 27.8991 8.01266 35.9117 17.8968 35.9117Z" fill="#EBB34D"/>
<path d="M11.4733 20.0201C11.4733 20.0201 17.3399 18.4978 24.3575 20.0201C24.3575 20.0201 24.5803 28.3002 17.9339 28.3002C11.2505 28.3002 11.4733 20.0201 11.4733 20.0201Z" fill="#5B0600"/>
<path d="M13.3669 13.0396C13.3669 13.0396 12.9214 11.2944 10.7307 11.2944C8.65137 11.2944 8.09442 13.0396 8.09442 13.0396" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
<path d="M26.5852 13.0396C26.5852 13.0396 26.1397 11.2944 23.949 11.2944C21.8697 11.2944 21.3127 13.0396 21.3127 13.0396" stroke="black" stroke-width="2" stroke-miterlimit="10" stroke-linecap="round" stroke-linejoin="round"/>
</svg>""";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitial) {
      surveyData =
          ModalRoute.of(context)?.settings.arguments as foodList.SurveyData;

      bloc = SurveyCallSupportBloc();
      bloc.getCallSurveyCauses();

      listenBloc();

      isInitial = true;
    }
  }

  void listenBloc() {
    bloc.showServerError.listen((event) {
      MemoryApp.isShowDialog = false;
      Navigator.of(context).pop();
      Utils.getSnackbarMessage(context, intl.offError);
    });

    bloc.popLoading.listen((event) {
      Navigator.of(context).pop();
    });

    bloc.navigateTo.listen((event) {
      context.vxNav.push(Uri.parse(Routes.listView));
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    setContactedToMe();

    return SurveyCallSupportProvider(bloc, child: body());
  }

  void setContactedToMe() {
    PollPhrases pollPhrase = new PollPhrases();
    pollPhrase.cause = intl.isContactedToMe;
    pollPhrase.isActive = boolean.False;

    bloc.setContactedToMe = pollPhrase;
  }

  Widget body() {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: Toolbar(titleBar: intl.surveyCallSupport),
        body: SafeArea(
          child: TouchMouseScrollable(
            child: SingleChildScrollView(
              child: Container(
                width: 100.w,
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: StreamBuilder<PollPhrases>(
                    stream: bloc.isContactedToMe,
                    builder: (context, isContactedToMe) {
                      if (isContactedToMe.hasData)
                        return Column(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 16, left: 16, right: 16, bottom: 8),
                            child: Text(intl.surveyCallSupportEmojiTitle,
                                textAlign: TextAlign.center,
                                style: typography.caption!
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 8, left: 16, right: 16, bottom: 8),
                            child: Text(intl.surveyCallSupportEmojiDescription,
                                textAlign: TextAlign.center,
                                style: typography.caption!
                                    .copyWith(fontSize: 10.sp)),
                          ),
                          isContactedToMeBox(isContactedToMe.requireData),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: selectEmojiContainer(
                                isContactedToMe.requireData),
                          ),
                          Space(height: 3.h),
                          StrengthsWeaknessTabs(),
                          Space(height: 3.h),
                          registerSurvey(),
                          Space(height: 2.h),
                        ]);
                      else
                        return Progress();
                    }),
              ),
            ),
          ),
        ));
  }

  Widget isContactedToMeBox(PollPhrases pollPhrase) {
    return ItemPollPhrase(
        pollPhrase: pollPhrase,
        click: () {
          if (pollPhrase.isActive! == boolean.True) {
            pollPhrase.isActive = boolean.False;
          } else {
            pollPhrase.isActive = boolean.True;
            bloc.pollsReset();
          }

          bloc.setContactedToMe = pollPhrase;
        });
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
              EmojiSelected.EXTRA_UPSET, extraUpsetEmoji, '#DD5F70', '#717171'),
          showEmojiFromString(
              EmojiSelected.UPSET, upsetEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(
              EmojiSelected.NEUTRAL, neutralEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(
              EmojiSelected.HAPPY, happyEmoji, '#EBB34D', '#717171'),
          showEmojiFromString(
              EmojiSelected.EXTRA_HAPPY, extraHappyEmoji, '#EBB34D', '#717171')
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
                    fontWeight: FontWeight.bold,
                    color: AppColors.greyDate.withOpacity(0.1)))),
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
                    : showEmojiFromString(EmojiSelected.EXTRA_UPSET,
                        extraUpsetEmoji, '#DD5F70', '#717171'),
                emojiSelected.requireData == EmojiSelected.UPSET
                    ? showEmojiSelected(
                        'assets/images/emoji/face_with_cold_sweat.svg')
                    : showEmojiFromString(
                        EmojiSelected.UPSET, upsetEmoji, '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.NEUTRAL
                    ? showEmojiSelected('assets/images/emoji/neutral_face.svg')
                    : showEmojiFromString(EmojiSelected.NEUTRAL, neutralEmoji,
                        '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.HAPPY
                    ? showEmojiSelected(
                        'assets/images/emoji/white_smiling_face.svg')
                    : showEmojiFromString(
                        EmojiSelected.HAPPY, happyEmoji, '#EBB34D', '#717171'),
                emojiSelected.requireData == EmojiSelected.EXTRA_HAPPY
                    ? showEmojiSelected(
                        'assets/images/emoji/smiling_face_with_open_mouth.svg')
                    : showEmojiFromString(EmojiSelected.EXTRA_HAPPY,
                        extraHappyEmoji, '#EBB34D', '#717171')
              ]),
              Container(
                  width: 60.w,
                  margin: EdgeInsets.all(8),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.redBar.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: showEmojiSelectedText(
                      emojiSelected.requireData, surveyRates)),
            ],
          );
        });
  }

  Widget showEmojiSelectedText(
      EmojiSelected emojiSelected, List<SurveyRates> surveyRates) {
    switch (emojiSelected) {
      case EmojiSelected.EXTRA_UPSET:
        return Text(
            surveyRates[0].title ?? intl.surveyCallSupportEmojiTextRate1,
            textAlign: TextAlign.center,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.UPSET:
        return Text(
            surveyRates[1].title ?? intl.surveyCallSupportEmojiTextRate2,
            textAlign: TextAlign.center,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.NEUTRAL:
        return Text(
            surveyRates[2].title ?? intl.surveyCallSupportEmojiTextRate3,
            textAlign: TextAlign.center,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.HAPPY:
        return Text(
            surveyRates[3].title ?? intl.surveyCallSupportEmojiTextRate4,
            textAlign: TextAlign.center,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.redBar));
      case EmojiSelected.EXTRA_HAPPY:
        return Text(
            surveyRates[4].title ?? intl.surveyCallSupportEmojiTextRate5,
            textAlign: TextAlign.center,
            style: typography.caption!.copyWith(
                fontWeight: FontWeight.bold, color: AppColors.redBar));
    }
  }

  Widget showEmojiSelected(String iconPath) {
    return Container(
      width: 12.w,
      height: 6.h,
      decoration: BoxDecoration(
        color: AppColors.redBar.withOpacity(0.1),
        borderRadius: BorderRadius.circular(100),
      ),
      child: showEmojiFromPath(iconPath),
    );
  }

  Widget showEmojiFromPath(String path) {
    return ImageUtils.fromLocal(path,
        width: 9.w, height: 9.w, margin: EdgeInsets.all(8));
  }

  Widget showEmojiFromString(EmojiSelected emojiSelected, String stringSvg,
      String colorPatternFrom, String colorPatternReplace) {
    return InkWell(
      onTap: () {
        bloc.setEmojiSelected = emojiSelected;
        debugPrint("EmojiSelected ${emojiSelected}");
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

  Widget registerSurvey() {
    return Container(
        margin: EdgeInsets.all(2.w),
        child: SubmitButton(
            label: intl.registerSurvey,
            onTap: () {
              DialogUtils.showDialogProgress(context: context);

              sendCallRequest();
            }));
  }

  void sendCallRequest() {
    if (bloc.isContactedMe.isActive == boolean.False) {
      CallRateRequest callRateRequest = CallRateRequest();

      List<PollPhrases> pollPhrasesArrayStrengths =
          bloc.pollPhrasesArrayStrengths;
      List<PollPhrases> pollPhrasesArrayWeakness =
          bloc.pollPhrasesArrayWeakness;

      callRateRequest.surveyCauseIds = [];

      for (int i = 0; i < pollPhrasesArrayStrengths.length; i++) {
        PollPhrases pollPhrase = pollPhrasesArrayStrengths[i];
        if (pollPhrase.isActive! == boolean.True)
          callRateRequest.surveyCauseIds!.add(pollPhrase.id!);
      }

      for (int i = 0; i < pollPhrasesArrayWeakness.length; i++) {
        PollPhrases pollPhrase = pollPhrasesArrayWeakness[i];
        if (pollPhrase.isActive! == boolean.True)
          callRateRequest.surveyCauseIds!.add(pollPhrase.id!);
      }

      callRateRequest.callId = surveyData.callId;
      callRateRequest.isContactedMe =
          bloc.isContactedMe.isActive! == true ? true : false;
      callRateRequest.userRate = bloc.getEmojiSelected.value;

      bloc.sendCallRequest(callRateRequest);
    } else {
      CallRateRequest callRateRequest = CallRateRequest();
      callRateRequest.callId = surveyData.callId;
      callRateRequest.isContactedMe =
          bloc.isContactedMe.isActive! == true ? true : false;
      callRateRequest.userRate = 1;
      callRateRequest.surveyCauseIds = [];

      bloc.sendCallRequest(callRateRequest);
    }
  }

  @override
  void dispose() {
    super.dispose();

    bloc.dispose();
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
  void onShowMessage(String value) {}
}
