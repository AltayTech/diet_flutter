import 'dart:core';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/item_poll_phrase.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:flutter/material.dart';

class StrengthsTab extends StatefulWidget {
  StrengthsTab() {}

  @override
  _StrengthsTabState createState() => _StrengthsTabState();
}

class _StrengthsTabState extends ResourcefulState<StrengthsTab> {
  bool showOpenDialog = false;

  late TicketBloc ticketBloc;

  List<PollPhrases>? list = [];

  @override
  void initState() {
    super.initState();
    ticketBloc = TicketBloc();

    PollPhrases pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 1 عبارت تستی 1 عبارت تستی 1";
    pollPhrases.isSelected = true;

    list!.add(pollPhrases);

    pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 2";
    pollPhrases.isSelected = false;

    list!.add(pollPhrases);
  }

  @override
  void dispose() {
    ticketBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return body(); /*TicketProvider(ticketBloc,
        child: Scaffold(
          backgroundColor: AppColors.newBackground,
          body: body(),
        ));*/
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
    return list != null && list!.length > 0
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: list!.length,
                itemBuilder: (BuildContext context, int index) =>
                    ItemPollPhrase(
                        text: list![index].text!,
                        isSelected: list![index].isSelected!)),
          )
        : Container(
            height: 20.h,
            child: Center(
                child: Text(intl.subscriptionPackageNotAvailable,
                    style: typography.caption)),
          );
  }

  @override
  void onRetryLoadingPage() {}
}
