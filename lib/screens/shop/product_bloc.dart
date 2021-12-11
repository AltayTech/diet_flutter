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
  bool _checkLatestInvoice = false;

  List<Lessons>? _lessons;
  List<ProductMedia>? _media;

  final _IsBought = BehaviorSubject<bool>();
  final _ = BehaviorSubject<bool>();
  final _product = BehaviorSubject<ShopProduct>();

  final _loadingMoreProducts = BehaviorSubject<bool>();
  final _selectedProduct = BehaviorSubject<int>();
  final _navigateToVerify = LiveEvent();
  final _onlinePayment = LiveEvent();
  final _showServerError = LiveEvent();

  bool get checkLatestInvoice => _checkLatestInvoice;

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

  Stream get onlinePayment => _onlinePayment.stream;

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

  final _typeMediaShop = BehaviorSubject<TypeMediaShop>();

  void getProduct(int id) async {
    if (tempDir == null) {
      tempDir = await getExternalStorageDirectory();
    }
    _loadingMoreProducts.value = true;
    try {
      _repository.getProduct(id).then((value) {
        _product.value = value.data!;
        _lessons = value.data!.lessons;
        if (_lessons != null) {
          _lessons?.forEach((element) async {
            if (element.video != null && element.video!.trim().length > 1) {
              debugPrint(
                  'element.video => ${tempDir?.path}/${element.video?.split('/').last} // ${_product.value.userOrderDate}');
              element.path = '${tempDir!.path}/${element.video!.split('/').last}';
              bool exist =
                  await File('${element.path}').exists();
              if (exist) {
                element.typeMediaShop = TypeMediaShop.play;
              } else if (element.isFree == 0 && _product.value.userOrderDate == null) {
                element.typeMediaShop = TypeMediaShop.lock;
              } else {
                element.typeMediaShop = TypeMediaShop.download;
              }
            } else {
              element.typeMediaShop = TypeMediaShop.lock;
            }
          });
          _typeMediaShop.value = TypeMediaShop.download;
        }
      }).whenComplete(() => _loadingMoreProducts.value = false);
    } catch (e) {
      print("error:$e");
    }
  }
  void downloadFile(Lessons value) async {
    value.typeMediaShop = TypeMediaShop.progress;
    _typeMediaShop.value = TypeMediaShop.progress;
    _repository.download(value.video!, value.path!).then((param) {
      debugPrint('path => ${value.path!}');
      value.typeMediaShop = TypeMediaShop.play;
      _typeMediaShop.value = value.typeMediaShop!;
    }).catchError((onError) {
      value.typeMediaShop = TypeMediaShop.download;
      _typeMediaShop.value = TypeMediaShop.download;
    });
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
      if(value.data?.url != null && value.data!.url!.isNotEmpty) _checkLatestInvoice = true;
      _onlinePayment.fire(value.data?.url ?? null);
    }).whenComplete(() => _loadingMoreProducts.value = false);
  }

  void mustCheckLastInvoice() {
    _checkLatestInvoice = true;
  }

  void checkLastInvoice(){
    debugPrint('last invoice ${checkLatestInvoice}');
    // if(!_checkLatestInvoice.isNullOrFalse) {
      _loadingMoreProducts.value = true;
      _repository.shopLastInvoice().then((value) {
        if (value.data?.refId != null &&
            !value.requireData.success.isNullOrFalse &&
            !value.requireData.resolved.isNullOrFalse)
          _navigateToVerify.fire(true);
        else
          _navigateToVerify.fire(false);
      }).whenComplete(() => _loadingMoreProducts.value = false);
    // }
  }

  void dispose() {
    _IsBought.close();
    _showServerError.close();
    _navigateToVerify.close();
    _onlinePayment.close();
    _loadingMoreProducts.close();
    _typeMediaShop.close();
    _product.close();
  }
}
