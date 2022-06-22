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
  SurveyCallSupportBloc() {}

  List<SubscriptionsItems>? subscriptions;
  List<PollPhrases>? _pollPhrasesStrengths;
  List<PollPhrases>? _pollPhrasesWeakness;

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  final _emojiSelected = BehaviorSubject<EmojiSelected>();

  final _pollPhraseStrengths = BehaviorSubject<PollPhrases>();

  final _pollPhraseWeakness = BehaviorSubject<PollPhrases>();

  final _subscriptionPending = BehaviorSubject<SubscriptionPendingData?>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<EmojiSelected> get emojiSelected => _emojiSelected.stream;

  Stream<SubscriptionPendingData?> get subscriptionPending => _subscriptionPending.stream;

  Stream<PollPhrases> get pollPhrasesStrengths => _pollPhraseStrengths.stream;

  Stream<PollPhrases> get pollPhrasesWeakness => _pollPhraseWeakness.stream;

  set setEmojiSelected(EmojiSelected emoji) => _emojiSelected.safeValue = emoji;

  set setPollPhrasesStrengths(PollPhrases pollPhrases) => _pollPhraseStrengths.safeValue = pollPhrases;

  set setPollPhrasesWeakness(PollPhrases pollPhrases) => _pollPhraseWeakness.safeValue = pollPhrases;

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
