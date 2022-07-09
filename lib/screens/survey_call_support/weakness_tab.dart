import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class WeaknessTab extends StatefulWidget {
  WeaknessTab() {}

  @override
  _WeaknessTabState createState() => _WeaknessTabState();
}

class _WeaknessTabState extends ResourcefulState<WeaknessTab> {
  bool showOpenDialog = false;

  late SurveyCallSupportBloc bloc;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    bloc = SurveyCallSupportProvider.of(context);

    return body();
  }

  Widget body() {
    return Container(
      decoration: AppDecorations.boxSmall.copyWith(
        color: Colors.white,
      ),
      child: content(),
    );
  }

  Widget content() {
    return StreamBuilder<bool>(
        initialData: true,
        stream: bloc.progressNetwork,
        builder: (context, progress) {
          if (!progress.requireData)
            return StreamBuilder<PollPhrases>(
              stream: bloc.isContactedToMe,
              builder: (context, isContactedToMe) {
                return StreamBuilder<List<PollPhrases>>(
                    stream: bloc.pollPhrasesWeakness,
                    builder: (context, pollPhrases) {
                      return pollPhrases.hasData &&
                              pollPhrases.requireData.length > 0
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListView.builder(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: pollPhrases.requireData.length,
                                  itemBuilder:
                                      (BuildContext context, int index) => item(
                                          isContactedToMe.requireData.isActive!,
                                          pollPhrases.requireData[index],
                                          index)),
                            )
                          : Container(
                              height: 20.h,
                              child: Center(
                                  child: Text(intl.noPollSurveyAvailable,
                                      style: typography.caption)),
                            );
                    });
              },
            );
          else
            return Center(child: Progress());
        });
  }

  Widget item(boolean isDisable, PollPhrases pollPhrases, int index) {
    return ItemPollPhrase(
        pollPhrase: pollPhrases,
        click: () {
          if (isDisable == boolean.False) {
            if (pollPhrases.isActive! == boolean.True) {
              pollPhrases.isActive = boolean.False;
            } else {
              pollPhrases.isActive = boolean.True;
            }

            if (pollPhrases.isPositive! == boolean.True) {
              bloc.setPollPhrasesStrengths(pollPhrases, index);
            } else {
              bloc.setPollPhrasesWeakness(pollPhrases, index);
            }
          }
        });
  }

  @override
  void onRetryLoadingPage() {}
}
