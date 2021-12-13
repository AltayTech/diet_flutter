import 'dart:async';

import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class CategoryBloc {
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

  bool get _stillHaveMoreItems => (_categoryProduct.valueOrNull?.length ?? 0) < _totalRow;

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<ShopCategory> get category => _category.stream;

  Stream<List<ShopProduct>> get categoryProduct => _categoryProduct.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;

  String get filter {
    final text =
        '{"page":{"offset":${_offset * 30},"limit":30},"filters":[[{"field":"category_id","op":"=","value":${_category.value.id}}]]}';
    return text;
  }

  void getCategory(String id) {
    _loadingContent.value = true;
    _loadingMoreProducts.value = true;
    _repository.getCategory(id).then((value) {
      // _category.add(value.data!);
      _category.value = value.data!;
      getProducts();
    }).whenComplete(() {});
  }

  void getProducts() {
    _repository.getProducts(filter).then((value) {
      if (value.data!.items!.length > 0) {
        if (_categoryProduct.valueOrNull == null)
          _categoryProduct.value = value.data!.items!;
        else
          _categoryProduct.value.addAll(value.data!.items!);

        _totalRow = _categoryProduct.valueOrNull?.length ?? 0;
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
      getProducts();
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
