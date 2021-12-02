import 'dart:async';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class CategoryBloc{
  CategoryBloc(){
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  int _offset = 0;
  int _totalRow = 0;
  final _waiting = BehaviorSubject<bool>();
  final _products = BehaviorSubject<List<ShopProduct>>();
  final _loadingMoreProducts = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingMoreProducts => _loadingMoreProducts.stream;
  bool get _isNotLoadingMore => _loadingMoreProducts.valueOrNull.isNullOrFalse;
  // bool get _stillHaveMoreItems =>
  //     (_products.valueOrNull?.length ?? 0) < _totalRow &&
          // _listFood.valueOrNull?.items.foods?.length != 0;
  Stream<bool> get waiting => _waiting.stream;
  Stream<List<ShopProduct>> get products => _products.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;

  void onScrollReachingEnd() {
    if (_isNotLoadingMore
        // && _stillHaveMoreItems
    ) {
      _offset++;
      getProduct();
    }
  }

  void getProduct(){
    _loadingMoreProducts.value = true;
    _repository.getProduct().then((value) {
      _products.value = value.data!.items!;
    }).whenComplete(() => _loadingMoreProducts.value = false);
  }

  void dispose() {
    _waiting.close();
    _showServerError.close();
    _navigateToVerify.close();
    _loadingMoreProducts.close();
  }
}
