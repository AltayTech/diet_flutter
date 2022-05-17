import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:rxdart/rxdart.dart';

class HistorySubscriptionPaymentBloc {
  HistorySubscriptionPaymentBloc() {}

  List<SubscriptionsItems>? subscriptions;

  final _repository = Repository.getInstance();

  final _progressNetwork = BehaviorSubject<bool>();

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  void getUserSubscriptions() {
    _progressNetwork.value = true;

    _repository.getUserSubscription().then((value) {
      subscriptions = value.data!.items!.subscriptionList;
      print('subscriptions => ${subscriptions}');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void dispose() {
    _progressNetwork.close();
  }
}
