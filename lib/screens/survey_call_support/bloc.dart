import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

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

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  final _emojiSelected = BehaviorSubject<EmojiSelected>();

  final _subscriptionPending = BehaviorSubject<SubscriptionPendingData?>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<EmojiSelected> get emojiSelected => _emojiSelected.stream;

  Stream<SubscriptionPendingData?> get subscriptionPending => _subscriptionPending.stream;

  set setEmojiSelected(EmojiSelected emoji) => _emojiSelected.safeValue = emoji;

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
