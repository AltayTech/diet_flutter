import 'dart:async';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';
import 'package:behandam/extensions/stream.dart';

class OrdersBloc{
  OrdersBloc(){
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  int? _count;
  final _waiting = BehaviorSubject<bool>();
  final _orders = BehaviorSubject<List<ShopProduct>>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  int? get count => _count;
  Stream<bool> get waiting => _waiting.stream;
  Stream<List<ShopProduct>> get orders => _orders.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;


  void getOrders(){
    _repository.getOrders().then((value) {
      _count = value.data!.count!;
      _orders.value = value.data!.items!;
    });
  }

  void dispose() {
    _waiting.close();
    _showServerError.close();
    _navigateToVerify.close();
    _orders.close();
  }
}
