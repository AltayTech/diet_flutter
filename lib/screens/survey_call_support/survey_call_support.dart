import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/list_view/food_list.dart' as foodList;
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/emoji_box.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/survey_call_support/strengths_weakness_tabs.dart';
import 'package:behandam/screens/widget/dialog.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/submit_button.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';
import 'package:touch_mouse_behavior/touch_mouse_behavior.dart';
import 'package:velocity_x/velocity_x.dart';

class SurveyCallSupportScreen extends StatefulWidget {
  const SurveyCallSupportScreen({Key? key}) : super(key: key);

  @override
  _SurveyCallSupportScreenState createState() => _SurveyCallSupportScreenState();
}

class _SurveyCallSupportScreenState extends ResourcefulState<SurveyCallSupportScreen> {
  late SurveyCallSupportBloc bloc;
  late foodList.SurveyData surveyData;
  bool isInitial = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInitial) {
      surveyData = ModalRoute.of(context)?.settings.arguments as foodList.SurveyData;

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
                            padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                            child: Text(intl.surveyCallSupportEmojiTitle,
                                textAlign: TextAlign.center,
                                style: typography.caption!.copyWith(fontWeight: FontWeight.bold)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 8),
                            child: Text(intl.surveyCallSupportEmojiDescription,
                                textAlign: TextAlign.center,
                                style: typography.caption!.copyWith(fontSize: 10.sp)),
                          ),
                          isContactedToMeBox(isContactedToMe.requireData),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: EmojiBox(
                              isContactedToMe: isContactedToMe.requireData,
                            ),
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

      List<PollPhrases> pollPhrasesArrayStrengths = bloc.pollPhrasesArrayStrengths;
      List<PollPhrases> pollPhrasesArrayWeakness = bloc.pollPhrasesArrayWeakness;

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
      // if is not contacted to me checked is contacted to me must false
      callRateRequest.isContactedMe = bloc.isContactedMe.isActive! == true ? false : true;
      callRateRequest.userRate = bloc.getEmojiSelected.value;

      bloc.sendCallRequest(callRateRequest);
    } else {
      CallRateRequest callRateRequest = CallRateRequest();
      callRateRequest.callId = surveyData.callId;
      // if is not contacted to me checked is contacted to me must false
      callRateRequest.isContactedMe = bloc.isContactedMe.isActive! == true ? false : true;
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
    DialogUtils.showDialogProgress(context: context);
    sendCallRequest();
  }

  @override
  void onRetryAfterNoInternet() {
    DialogUtils.showDialogProgress(context: context);
    sendCallRequest();
  }

  @override
  void onRetryLoadingPage() {
    bloc = SurveyCallSupportBloc();
    bloc.getCallSurveyCauses();
  }
}
