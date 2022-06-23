import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

import '../../data/entity/poll_phrases/poll_phrases.dart';

enum EmojiSelected {
  EXTRA_UPSET,
  UPSET,
  NEUTRAL,
  HAPPY,
  EXTRA_HAPPY
}

class SurveyCallSupportBloc {
  SurveyCallSupportBloc() {
    // strengths
    PollPhrases pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 1 عبارت تستی 1 عبارت تستی 1";
    pollPhrases.isSelected = true;
    pollPhrases.isStrength = true;
    pollPhrases.index = 0;

    listStrengths!.add(pollPhrases);

    pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 2";
    pollPhrases.isSelected = false;
    pollPhrases.isStrength = true;
    pollPhrases.index = 1;

    listStrengths!.add(pollPhrases);

    _pollPhrasesStrengths.safeValue = listStrengths!;

    // weakness
    pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 1";
    pollPhrases.isSelected = true;
    pollPhrases.isStrength = false;
    pollPhrases.index = 0;

    listWeakness!.add(pollPhrases);

    pollPhrases = new PollPhrases();
    pollPhrases.text = "عبارت تستی 2";
    pollPhrases.isSelected = false;
    pollPhrases.isStrength = false;
    pollPhrases.index = 1;

    listWeakness!.add(pollPhrases);

    _pollPhrasesWeakness.safeValue = listWeakness!;
  }

  List<PollPhrases>? listStrengths = [];
  List<PollPhrases>? listWeakness = [];

  List<SubscriptionsItems>? subscriptions;

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  final _emojiSelected = BehaviorSubject<EmojiSelected>();

  final _pollPhrasesStrengths = BehaviorSubject<List<PollPhrases>>();

  final _pollPhrasesWeakness = BehaviorSubject<List<PollPhrases>>();

  final _subscriptionPending = BehaviorSubject<SubscriptionPendingData?>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<EmojiSelected> get emojiSelected => _emojiSelected.stream;

  Stream<SubscriptionPendingData?> get subscriptionPending => _subscriptionPending.stream;

  Stream<List<PollPhrases>> get pollPhrasesStrengths => _pollPhrasesStrengths.stream;

  Stream<List<PollPhrases>> get pollPhrasesWeakness => _pollPhrasesWeakness.stream;

  set setEmojiSelected(EmojiSelected emoji) => _emojiSelected.safeValue = emoji;

  set setPollPhrasesStrengths(PollPhrases pollPhrases) {
    List<PollPhrases> p = _pollPhrasesStrengths.value;
    p[pollPhrases.index!] = pollPhrases;

    _pollPhrasesStrengths.safeValue = p;
  }

  set setPollPhrasesWeakness(PollPhrases pollPhrases) {
    List<PollPhrases> p = _pollPhrasesWeakness.value;
    p[pollPhrases.index!] = pollPhrases;

    _pollPhrasesWeakness.safeValue = p;
  }

  void getUserSubscriptions() {
    _progressNetwork.value = true;

    _repository.getUserSubscription().then((value) {
      subscriptions = value.data!.subscriptionList;
      _subscriptionPending.safeValue = value.data?.pendingCardPayment;
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void dispose() {
    _progressNetwork.close();
  }
}
