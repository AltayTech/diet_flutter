import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/utils/device.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

import '../../routes.dart';
import 'package:behandam/extensions/stream.dart';

enum PaymentDate {
  today,
  customDate
}


enum ProductType {
  SHOP,
  PACKAGE,
}

class PaymentBloc {
  PaymentBloc() {
    _waiting.safeValue = false;
    _discountLoading.value = false;
    _selectedDateType.value = PaymentDate.today;

    _invoice = LatestInvoiceData();
  }

  final _repository = Repository.getInstance();

  late String? _path;
  int? _productId;
  String? discountCode;
  PackageItem? _packageItem;
  Price? _discountInfo;
  LatestInvoiceData? _invoice;
  bool _checkLatestInvoice = false;
  String? _date;

  final _waiting = BehaviorSubject<bool>();
  final _showInformation = BehaviorSubject<bool>();
  final _online = BehaviorSubject<bool>();
  final _cardToCard = BehaviorSubject<bool>();
  final _wrongDisCode = BehaviorSubject<bool>();
  final _discountLoading = BehaviorSubject<bool>();
  final _usedDiscount = BehaviorSubject<bool>();
  final _selectedDateType = BehaviorSubject<PaymentDate>();
  final _selectedDate = BehaviorSubject<String>();
  final _productType = BehaviorSubject<ProductType>();
  final _navigateTo = LiveEvent();
  final _popLoading = LiveEvent();
  final _showServerError = LiveEvent();
  final _onlinePayment = LiveEvent();

  String? get date => _date;

  String? get path => _path;

  int? get productId => _productId;

  bool get checkLatestInvoice => _checkLatestInvoice;

  LatestInvoiceData? get invoice => _invoice;

  PackageItem? get packageItem => _packageItem;

  Price? get discountInfo => _discountInfo;

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get showInformation => _showInformation.stream;

  Stream<bool> get onlineStream => _online.stream;

  Stream<bool> get cardToCardStream => _cardToCard.stream;

  bool get isOnline => _online.valueOrNull ?? true;

  bool get isCardToCard => _cardToCard.valueOrNull ?? false;

  Stream<bool> get wrongDisCode => _wrongDisCode.stream;

  bool get isWrongDisCode => _wrongDisCode.valueOrNull ?? false;

  Stream<bool> get discountLoading => _discountLoading.stream;

  Stream<bool> get usedDiscount => _usedDiscount.stream;

  bool get isUsedDiscount => _usedDiscount.valueOrNull ?? false;

  Stream get navigateTo => _navigateTo.stream;

  Stream get popLoading => _popLoading.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get onlinePayment => _onlinePayment.stream;

  Stream<ProductType> get productType => _productType.stream;

  Stream<PaymentDate> get selectedDateType => _selectedDateType.stream;

  Stream<String> get selectedDate => _selectedDate.stream;

  set setSelectedDateType(PaymentDate date) => _selectedDateType.value = date;

  set setSelectedDate(String date) => _selectedDate.value = date;

  set setInvoice(LatestInvoiceData invoice) => _invoice = invoice;

  set setDate(String date) => _date = date;

  void mustCheckLastInvoice() {
    _checkLatestInvoice = true;
  }

  void newPayment(LatestInvoiceData newInvoice) {
    _repository.newPayment(newInvoice).then((value) {
      MemoryApp.analytics!.logEvent(
          name:
              '${navigator.currentConfiguration!.path.replaceAll("/", "_").substring(1).split("_")[0]}_payment_cart_record');
      MemoryApp.analytics!.logEvent(name: "total_payment_cart_record");
      _navigateTo.fire(value.next);
    }).whenComplete(() => _popLoading.fire(true));
  }

  void getPackagePayment() {
    _waiting.safeValue = true;
    _repository.getPackagePayment().then((value) {
      _packageItem = value.data;
      _packageItem!.price!.totalPrice = _packageItem!.price!.finalPrice;
    }).whenComplete(() {
      _waiting.safeValue = false;
    });
  }

  void selectUserPayment() {
    if (!isUsedDiscount && (discountCode != null && discountCode!.trim().isNotEmpty)) {
      _showServerError.fireMessage('error');
    } else {
      Payment payment = new Payment();
      payment.originId = kIsWeb
          ? 0
          : Device.get().isIos
              ? 2
              : 3;
      payment.coupon = discountCode;
      payment.paymentTypeId = (discountInfo != null && discountInfo!.finalPrice == 0)
          ? 2
          : isOnline
              ? 0
              : 1;
      _repository.setPaymentType(payment).then((value) {
        _navigateTo.fire(value);
      });
    }
  }

  void changeDiscountLoading(bool val) {
    _discountLoading.value = val;
  }

  void changeWrongDisCode(bool val) {
    _wrongDisCode.value = val;
  }

  void checkCode(String val) {
    MemoryApp.analytics!.logEvent(name: "discount_code");
    _discountLoading.value = true;
    Price price = new Price();
    price.code = val;
    _repository.checkCoupon(price).then((value) {
      _discountInfo = value.data;
      _packageItem!.price!.totalPrice = _discountInfo!.finalPrice;
      _usedDiscount.value = true;
      _online.value = true;
      MemoryApp.analytics!.logEvent(name: "discount_code_success");
    }).catchError((err) {
      _usedDiscount.value = false;
      _wrongDisCode.value = true;
      MemoryApp.analytics!.logEvent(name: "discount_code_fail");
    }).whenComplete(() {
      _discountLoading.value = false;
    });
  }

  void setOnline() {
    _online.value = true;
    _cardToCard.value = false;
  }

  void setCardToCard() {
    print('setCardToCard');
    _online.value = false;
    _cardToCard.value = true;
  }

  void getLastInvoice() {
    _waiting.safeValue = true;
    _repository.latestInvoice().then((value) {
      _invoice = value.data;
      _invoice!.payedAt = DateTime.now().toString().substring(0, 10);
      _path = value.next!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void checkLastInvoice() {
    _waiting.safeValue = true;
    _repository.latestInvoice().then((value) {
      if (value.data?.refId != null &&
          value.data?.success != null &&
          value.data?.resolved == true &&
          value.data?.payedAt != null &&
          value.next != null)
        _navigateTo.fire(value.next);
      else if (value.data?.note != null) {
        _showServerError.fireMessage(value.data!.note!);
      }
      _invoice = value.data;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void checkOnlinePayment() {
    _repository.latestInvoice().then((value) {
      _onlinePayment.fire(value.data!.success);
      _path = value.next ?? null;
    });
  }

  void setShowInformation() {
    _showInformation.value = _showInformation.valueOrNull == null ? true : !_showInformation.value;
  }

  void shopLastInvoice() {
    // if(!_checkLatestInvoice.isNullOrFalse) {
    _waiting.safeValue = true;
    _repository.shopLastInvoice().then((value) {
      _invoice = value.data;
      if (value.data?.refId != null &&
          !value.requireData.success.isNullOrFalse &&
          !value.requireData.resolved.isNullOrFalse) {
        _navigateTo.fire(Routes.shopOrders);
        _productId = value.requireData.productId;
        // debugPrint('shop last invoice $productId / ${value.requireData.productId}');
      } else
        _navigateTo.fire(Routes.shopHome);
    }).whenComplete(() => _waiting.safeValue = false);
    // }
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _popLoading.close();
    _discountLoading.close();
    _cardToCard.close();
    _online.close();
    _usedDiscount.close();
    _showInformation.close();
    _wrongDisCode.close();
    _waiting.close();
    _onlinePayment.close();
    _productType.close();
    _selectedDateType.close();
    _selectedDate.close();
  }

  void setProductType(ProductType productType) {
    _productType.safeValue = productType;
    if (_productType.value == ProductType.SHOP)
      shopLastInvoice();
    else
      getLastInvoice();
  }
}
