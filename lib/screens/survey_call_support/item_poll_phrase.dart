import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/screens/survey_call_support/bloc.dart';
import 'package:behandam/screens/survey_call_support/provider.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:logifan/widgets/space.dart';

class ItemPollPhrase extends StatefulWidget {
  late PollPhrases pollPhrase;

  ItemPollPhrase({required this.pollPhrase});

  @override
  _ItemPollPhraseState createState() => _ItemPollPhraseState();
}

class _ItemPollPhraseState extends ResourcefulState<ItemPollPhrase> {
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

    return _item(widget.pollPhrase);
  }

  Widget _item(PollPhrases pollPhrase) {
    return InkWell(
      onTap: () {
        if (pollPhrase.isSelected!) {
          pollPhrase.isSelected = false;
        } else {
          pollPhrase.isSelected = true;
        }

        if (pollPhrase.isStrength!) {
          bloc.setPollPhrasesStrengths = pollPhrase;
        } else {
          bloc.setPollPhrasesWeakness = pollPhrase;
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          textDirection: context.textDirectionOfLocaleInversed,
          children: <Widget>[
            Expanded(
                child: Text(pollPhrase.text!,
                    textAlign: TextAlign.start,
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(letterSpacing: -0.2, fontWeight: FontWeight.w400))),
            Space(width: 2.w),
            ImageUtils.fromLocal(
              pollPhrase.isSelected! ? 'assets/images/bill/check.svg' : 'assets/images/bill/not_select.svg',
              width: 4.w,
              height: 4.w,
            ),
          ],
        ),
      ),
    );
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
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
