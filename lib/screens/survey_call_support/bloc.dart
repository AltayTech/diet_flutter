import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/entity/poll_phrases/poll_phrases.dart';

enum EmojiSelected {
  EXTRA_UPSET(1),
  UPSET(2),
  NEUTRAL(3),
  HAPPY(4),
  EXTRA_HAPPY(5);

  final int value;

  const EmojiSelected(this.value);
}

class SurveyCallSupportBloc {
  SurveyCallSupportBloc() {
    setEmojiSelected = EmojiSelected.EXTRA_HAPPY;
  }

  List<PollPhrases>? listStrengths = [];
  List<PollPhrases>? listWeakness = [];

  final _repository = Repository.getInstance();
  final _progressNetwork = BehaviorSubject<bool>();
  final _emojiSelected = BehaviorSubject<EmojiSelected>();
  final _pollPhrasesStrengths = BehaviorSubject<List<PollPhrases>>();
  final _pollPhrasesWeakness = BehaviorSubject<List<PollPhrases>>();
  final _surveyRates = BehaviorSubject<List<SurveyRates>>();
  final _isContactedToMe = BehaviorSubject<PollPhrases>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popLoading = LiveEvent();

  Stream get navigateTo => _navigateTo.stream;

  Stream get popLoading => _popLoading.stream;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<EmojiSelected> get emojiSelected => _emojiSelected.stream;

  Stream<List<PollPhrases>> get pollPhrasesStrengths =>
      _pollPhrasesStrengths.stream;

  Stream<List<PollPhrases>> get pollPhrasesWeakness =>
      _pollPhrasesWeakness.stream;

  Stream<List<SurveyRates>> get surveyRates => _surveyRates.stream;

  Stream<PollPhrases> get isContactedToMe => _isContactedToMe.stream;

  List<PollPhrases> get pollPhrasesArrayStrengths =>
      _pollPhrasesStrengths.value;

  List<PollPhrases> get pollPhrasesArrayWeakness => _pollPhrasesWeakness.value;

  PollPhrases get isContactedMe => _isContactedToMe.value;

  EmojiSelected get getEmojiSelected => _emojiSelected.value;

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

  void sendCallRequest(CallRateRequest callRequest) {
    _repository.sendCallRate(callRequest).then((value) {
      _navigateTo.fire(true);
    }).whenComplete(() => _popLoading.fire(true));
  }

  void pollsReset() {
    if (_pollPhrasesStrengths.hasValue) {
      for (int i = 0; i < _pollPhrasesStrengths.value.length; i++) {
        PollPhrases pollPhrase = _pollPhrasesStrengths.value[i];
        pollPhrase.isActive = boolean.False;
        _pollPhrasesStrengths.value[i] = pollPhrase;
      }
    }
    if (_pollPhrasesWeakness.hasValue) {
      for (int i = 0; i < _pollPhrasesWeakness.value.length; i++) {
        PollPhrases pollPhrase = _pollPhrasesWeakness.value[i];
        pollPhrase.isActive = boolean.False;
        _pollPhrasesWeakness.value[i] = pollPhrase;
      }
    }
  }

  void dispose() {
    _navigateTo.close();
    _showServerError.close();
    _popLoading.close();
    _progressNetwork.close();
    _emojiSelected.close();
    _pollPhrasesStrengths.close();
    _pollPhrasesWeakness.close();
    _surveyRates.close();
    _isContactedToMe.close();
  }
}
