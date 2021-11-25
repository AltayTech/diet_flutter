import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:behandam/utils/device.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class PaymentBloc {
  PaymentBloc(){
    _waiting.value = false;
    _discountLoading.value = false;
  }

  late String _path;
  String? discountCode;
  PackageItem? _packageItem;
  Price? _discountInfo;
  LatestInvoiceData? _invoice;

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _latestInvoice = BehaviorSubject<LatestInvoiceData>();
  final _waiting = BehaviorSubject<bool>();
  final _online = BehaviorSubject<bool>();
  final _cardToCard = BehaviorSubject<bool>();
  final _wrongDisCode = BehaviorSubject<bool>();
  final _discountLoading = BehaviorSubject<bool>();
  final _usedDiscount = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _showInformation = BehaviorSubject<bool>();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<LatestInvoiceData> get latestInvoice => _latestInvoice.stream;

  String get path => _path;

  LatestInvoiceData? get invoice => _invoice;

  PackageItem? get packageItem => _packageItem;

  Stream<bool> get showInformation => _showInformation.stream;

  Price? get discountInfo => _discountInfo;

  Stream<bool> get waiting => _waiting.stream;

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

  Stream get showServerError => _showServerError.stream;

  void latestInvoiceLoad() {
    _loadingContent.value = true;
    _repository.latestInvoice().then((value) {
      _latestInvoice.value = value.data!;
      debugPrint('latest invoice bloc ${_latestInvoice.value.amount}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void newPayment(LatestInvoiceData newInvoice){
    _loadingContent.value = true;
    _repository.newPayment(newInvoice).then((value) {
      _latestInvoice.value = value.data!;
      debugPrint('new invoice bloc ${_latestInvoice.value.amount}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void getPackagePayment() {
    _waiting.value = true;
    _repository.getPackagePayment().then((value) {
      _packageItem = value.data;
    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void changeDiscountLoading(bool val) {
    _discountLoading.value = val;
  }

  void changeWrongDisCode(bool val) {
    _wrongDisCode.value = val;
  }

  void setOnline() {
    print('setOnline');
    _online.value = true;
    _cardToCard.value = false;
  }

  void setCardToCard() {
    print('setCardToCard');
    _online.value = false;
    _cardToCard.value = true;
  }

  void selectUserPayment() {
    Payment payment = new Payment();
    payment.originId = Device.get().isIos ? 2 : 3;
    payment.coupon = discountCode;
    payment.paymentTypeId =
    (discountInfo != null && discountInfo!.finalPrice == 0)
        ? 2
        : isOnline
        ? 0
        : 1;
    _repository.setPaymentType(payment).then((value) {
      _navigateTo.fire(value);
    });
  }

  void checkCode(String val) {
    _discountLoading.value = true;
    Price price = new Price();
    price.code = val;
    _repository.checkCoupon(price).then((value) {
      _discountInfo = value.data;
      _packageItem!.price!.finalPrice = _discountInfo!.finalPrice;
      _usedDiscount.value = true;
      _online.value = true;
    }).catchError((err) {
      _usedDiscount.value = false;
      _wrongDisCode.value = true;
    }).whenComplete(() {
      _discountLoading.value = false;
    });
  }

  void getLastInvoice() {
    _waiting.value = true;
    _repository.latestInvoice().then((value) {
      _invoice = value.data;
      _path = value.next!;
    }).whenComplete(() => _waiting.value = false);
  }

  void setShowInformation() {
    _showInformation.value =
    _showInformation.valueOrNull == null ? true : !_showInformation.value;
  }

  void dispose() {
    _loadingContent.close();
    _latestInvoice.close();
    _showServerError.close();
    _navigateTo.close();
    _discountLoading.close();
    _cardToCard.close();
    _online.close();
    _usedDiscount.close();
    _wrongDisCode.close();
    _waiting.close();
    _showInformation.close();
  }
}
