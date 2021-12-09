import 'dart:async';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/utils/device.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class CategoryBloc{
  CategoryBloc();

  final _repository = Repository.getInstance();

  int _offset = 0;
  int _totalRow = 0;

  final _loadingContent = BehaviorSubject<bool>();
  final _ = BehaviorSubject<bool>();
  final _category = BehaviorSubject<ShopCategory>();
  final _categoryProduct = BehaviorSubject<List<ShopProduct>>();
  final _loadingMoreProducts = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingMoreProducts => _loadingMoreProducts.stream;
  bool get _isNotLoadingMore => _loadingMoreProducts.valueOrNull.isNullOrFalse;
  bool get _stillHaveMoreItems =>
      (_categoryProduct.valueOrNull?.length ?? 0) < _totalRow;
  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream<ShopCategory> get category => _category.stream;
  Stream<List<ShopProduct>> get categoryProduct => _categoryProduct.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;

  String get filter {
    final text =
        '{"with":["products"]}';
        // '{"page":{"offset":${_offset * 30},"limit":30},"sort":[{"field":"title","dir":"asc"}],"filters":[[{"with":["products"]}]]}';
    return text;
  }

  void getCategory(String id){
    _loadingContent.value = true;
    _loadingMoreProducts.value = true;
    _repository.getCategory(id,filter).then((value) {
      // _category.add(value.data!);
      _category.value = value.data!;
      if(value.data!.products!.length > 0) {
        _categoryProduct.value = value.data!.products!;
        _totalRow = value.data?.products!.length ?? 0;
      }
    }).whenComplete(() {
      _loadingContent.value = false;
      _loadingMoreProducts.value = false;
    });
  }

  void onScrollReachingEnd() {
    // print('test:${_isNotLoadingMore && _stillHaveMoreItems}');
    if (_isNotLoadingMore && _stillHaveMoreItems) {
      _offset++;
      // getCategory('1');
    }
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _loadingContent.close();
    _loadingMoreProducts.close();
    _categoryProduct.close();
  }
}
