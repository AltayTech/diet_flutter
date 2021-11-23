import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/regime/payment.dart';
import 'package:behandam/utils/device.dart';
import 'package:rxdart/rxdart.dart';

class PaymentBloc {
  PackageBloc() {
    _waiting.value = false;
    _discountLoading.value = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  String? discountCode;
  PackageItem? _packageItem;
  Price? _discountInfo;

  final _waiting = BehaviorSubject<bool>();
  final _online = BehaviorSubject<bool>();
  final _cardToCard = BehaviorSubject<bool>();
  final _wrongDisCode = BehaviorSubject<bool>();
  final _discountLoading = BehaviorSubject<bool>();
  final _usedDiscount = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  PackageItem? get packageItem => _packageItem;

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

  void getPackagePayment() {
    _waiting.value = true;
    _repository.getPackagePayment().then((value) {
      _packageItem = value.data;
    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void selectUserPayment() {
    Payment payment = new Payment();
    payment.originId = Device.get().isIos ? 2 : 3;
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

  void changeDiscountLoading(bool val) {
    _discountLoading.value = val;
  }

  void changeWrongDisCode(bool val) {
    _wrongDisCode.value = val;
  }

  void checkCode(String val) {
    _discountLoading.value = true;
    Price price = new Price();
    price.code = val;
    _repository.checkCoupon(price).then((value) {
      _discountInfo = value.data;
      _usedDiscount.value = true;
    }).catchError((err) {
      _usedDiscount.value = false;
      _wrongDisCode.value = true;
    }).whenComplete(() {
      _discountLoading.value = false;
    });
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

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _discountLoading.close();
    _cardToCard.close();
    _online.close();
    _usedDiscount.close();
    _wrongDisCode.close();
    _waiting.close();
  }
}
