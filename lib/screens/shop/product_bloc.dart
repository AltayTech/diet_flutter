import 'dart:async';
import 'dart:io';

import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class ProductBloc {
  ProductBloc();

  final _repository = Repository.getInstance();
  Directory? tempDir;

  int _offset = 0;
  int _totalRow = 0;

  List<Lessons>? _lessons;
  List<ProductMedia>? _media;

  final _IsBought = BehaviorSubject<bool>();
  final _ = BehaviorSubject<bool>();
  final _products = BehaviorSubject<List<ShopProduct>>();
  final _product = BehaviorSubject<ShopProduct>();
  final _typeMediaShop = BehaviorSubject<TypeMediaShop>();
  final _loadingMoreProducts = BehaviorSubject<bool>();
  final _selectedProduct = BehaviorSubject<int>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  List<Lessons>? get lessons => _lessons;

  List<ProductMedia>? get media => _media;

  Stream<bool> get loadingMoreProducts => _loadingMoreProducts.stream;

  bool get _isNotLoadingMore => _loadingMoreProducts.valueOrNull.isNullOrFalse;

  // bool get _stillHaveMoreItems =>
  //     (_products.valueOrNull?.length ?? 0) < _totalRow &&
  // _listFood.valueOrNull?.items.foods?.length != 0;
  Stream<bool> get IsBought => _IsBought.stream;

  Stream<List<ShopProduct>> get products => _products.stream;

  Stream<ShopProduct> get product => _product.stream;

  Stream<TypeMediaShop> get typeMediaShop => _typeMediaShop.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;
  int? _productId;

  String get filter {
    final text;
    if (_selectedProduct.valueOrNull == null)
      text = '';
    else
      text = '{"filters":[[{"field":"id","op":"=","value":"${_productId ?? ""}"}]]"}';

    return text;
  }

  void onScrollReachingEnd() {
    if (_isNotLoadingMore
        // && _stillHaveMoreItems
        ) {
      _offset++;
      // getProduct();
    }
  }

  void getProducts() {
    _loadingMoreProducts.value = true;
    _repository.getProducts().then((value) {
      _products.value = value.data!.items!;
    }).whenComplete(() => _loadingMoreProducts.value = false);
  }

  void getProduct(int id) async {
    if (tempDir == null) {
      tempDir=  await getTemporaryDirectory();
    }
    _loadingMoreProducts.value = true;
    try {
      _repository.getProduct(id).then((value) {
        _product.value = value.data!;
        _lessons = value.data!.lessons;
        if (_lessons != null) {
          _lessons?.forEach((element) async {

            if (element.video != null && element.video!.trim().isNotEmpty) {
              debugPrint('element.video => ${tempDir?.path}/${element.video?.split('/').last} // ${element.video}');
              element.path = '${tempDir!.path}/${element.video!.split('/').last}';
              bool exist =
                  await File('${tempDir!.path}/${element.video!.lastIndexOf('/')}').exists();
              if (exist) {
                _typeMediaShop.value = TypeMediaShop.play;
              } else if (element.isFree == 0 && _product.value.userOrderDate == null) {
                _typeMediaShop.value = TypeMediaShop.lock;
              } else {
                _typeMediaShop.value = TypeMediaShop.download;
              }
            } else {
              _typeMediaShop.value = TypeMediaShop.lock;
            }
          });
        }
      }).whenComplete(() => _loadingMoreProducts.value = false);
    } catch (e) {
      print("error:$e");
    }
  }

  void onProduct(int newId) {
    _productId = newId;
    _offset = 0;
    // getProduct();
  }

  void onlinePaymentClick(int productId) {
    _loadingMoreProducts.value = true;
    //ToDo get selected product from bloc not from ui
    Payment shopPayment = Payment();
    shopPayment.originId = kIsWeb ? 5 : 6;
    shopPayment.paymentTypeId = 0;
    shopPayment.productId = productId;
    _repository.shopOnlinePayment(shopPayment).then((value) {
      _navigateToVerify.fire(value.data?.url ?? null);
    }).whenComplete(() => _loadingMoreProducts.value = false);
  }

  void dispose() {
    _IsBought.close();
    _showServerError.close();
    _navigateToVerify.close();
    _loadingMoreProducts.close();
    _typeMediaShop.close();
    _product.close();
  }
}
