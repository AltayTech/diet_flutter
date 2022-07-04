import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';

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
    return StreamBuilder<List<PollPhrases>>(
        stream: bloc.pollPhrasesWeakness,
        builder: (context, snapshot) {
          return snapshot.hasData && snapshot.requireData.length > 0
              ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: snapshot.requireData.length,
                itemBuilder: (BuildContext context, int index) =>
                    ItemPollPhrase(pollPhrase: snapshot.requireData[index])),
          )
              : Container(
            height: 20.h,
            child: Center(
                child: Text(intl.noPollSurveyAvailable,
                    style: typography.caption)),
          );
        });
  }

  @override
  void onRetryLoadingPage() {}
}
