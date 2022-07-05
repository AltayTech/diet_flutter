import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';

class StrengthsTab extends StatefulWidget {
  StrengthsTab() {}

  @override
  _StrengthsTabState createState() => _StrengthsTabState();
}

class _StrengthsTabState extends ResourcefulState<StrengthsTab> {
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
            return StreamBuilder<List<PollPhrases>>(
                stream: bloc.pollPhrasesStrengths,
                builder: (context, snapshot) {
                  return snapshot.hasData && snapshot.requireData.length > 0
                      ? Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                              physics: ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: snapshot.requireData.length,
                              itemBuilder: (BuildContext context, int index) =>
                                  ItemPollPhrase(
                                      pollPhrase: snapshot.requireData[index],
                                      click: () {
                                        if (snapshot
                                                .requireData[index].isActive! ==
                                            boolean.True) {
                                          snapshot.requireData[index].isActive =
                                              boolean.False;
                                        } else {
                                          snapshot.requireData[index].isActive =
                                              boolean.True;
                                        }

                                        if (snapshot.requireData[index]
                                                .isPositive! ==
                                            boolean.True) {
                                          bloc.setPollPhrasesStrengths(
                                              snapshot.requireData[index],
                                              index);
                                        } else {
                                          bloc.setPollPhrasesWeakness(
                                              snapshot.requireData[index],
                                              index);
                                        }
                                      })),
                        )
                      : Container(
                          height: 20.h,
                          child: Center(
                              child: Text(intl.noPollSurveyAvailable,
                                  style: typography.caption)),
                        );
                });
          else
            return Center(child: Progress());
        });
  }

  @override
  void onRetryLoadingPage() {}
}
