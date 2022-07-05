import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/entity/poll_phrases/poll_phrases.dart';

enum EmojiSelected { EXTRA_UPSET, UPSET, NEUTRAL, HAPPY, EXTRA_HAPPY }

class SurveyCallSupportBloc {
  SurveyCallSupportBloc() {}

  List<PollPhrases>? listStrengths = [];
  List<PollPhrases>? listWeakness = [];

  final _repository = Repository.getInstance();
  final _progressNetwork = BehaviorSubject<bool>();
  final _emojiSelected = BehaviorSubject<EmojiSelected>();
  final _pollPhrasesStrengths = BehaviorSubject<List<PollPhrases>>();
  final _pollPhrasesWeakness = BehaviorSubject<List<PollPhrases>>();
  final _surveyRates = BehaviorSubject<List<SurveyRates>>();
  final _isContactedToMe = BehaviorSubject<PollPhrases>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<EmojiSelected> get emojiSelected => _emojiSelected.stream;

  Stream<List<PollPhrases>> get pollPhrasesStrengths =>
      _pollPhrasesStrengths.stream;

  Stream<List<PollPhrases>> get pollPhrasesWeakness =>
      _pollPhrasesWeakness.stream;

  Stream<List<SurveyRates>> get surveyRates => _surveyRates.stream;

  Stream<PollPhrases> get isContactedToMe => _isContactedToMe.stream;

  set setContactedToMe(PollPhrases pollPhrase) =>
      _isContactedToMe.safeValue = pollPhrase;

  set setEmojiSelected(EmojiSelected emoji) => _emojiSelected.safeValue = emoji;

  void setPollPhrasesStrengths(PollPhrases pollPhrases, int index) {
    List<PollPhrases> p = _pollPhrasesStrengths.value;
    p[index] = pollPhrases;

    _pollPhrasesStrengths.safeValue = p;
  }

  void setPollPhrasesWeakness(PollPhrases pollPhrases, int index) {
    List<PollPhrases> p = _pollPhrasesWeakness.value;
    p[index] = pollPhrases;

    _pollPhrasesWeakness.safeValue = p;
  }

  void getCallSurveyCauses() {
    _progressNetwork.value = true;

    _repository.getCallSurveyCauses().then((value) {
      for (int i = 0; i < value.data!.surveyCauses!.length; i++) {
        PollPhrases pollPhrase = value.data!.surveyCauses![i];
        if (pollPhrase.isPositive == boolean.True) {
          listStrengths!.add(pollPhrase);
        } else {
          listWeakness!.add(pollPhrase);
        }
      }

      _pollPhrasesStrengths.safeValue = listStrengths!;
      _pollPhrasesWeakness.safeValue = listWeakness!;
      _surveyRates.safeValue = value.data!.surveyRates!;
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void dispose() {
    _progressNetwork.close();
    _emojiSelected.close();
    _pollPhrasesStrengths.close();
    _pollPhrasesWeakness.close();
    _surveyRates.close();
    _isContactedToMe.close();
  }
}
