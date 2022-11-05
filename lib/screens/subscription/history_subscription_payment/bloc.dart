import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

class HistorySubscriptionPaymentBloc {
  HistorySubscriptionPaymentBloc() {}

  List<SubscriptionsItems>? subscriptions;

  Repository _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  final _subscriptionPending = BehaviorSubject<SubscriptionPendingData?>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<SubscriptionPendingData?> get subscriptionPending => _subscriptionPending.stream;

  void getUserSubscriptions() {
    _progressNetwork.value = true;

    _repository.getUserSubscription().then((value) {
      subscriptions = value.data!.subscriptionList;
      _subscriptionPending.safeValue = value.data?.pendingCardPayment;
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryLoadingPage() {
    setRepository();
    getUserSubscriptions();
  }

  void dispose() {
    _progressNetwork.close();
  }
}
