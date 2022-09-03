import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/utils/device.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

enum PaymentType { online, cardToCard }

class BillPaymentBloc {
  BillPaymentBloc() {
    _discountLoading.value = false;
    _enterDiscount.value = false;
    _selectedPayment.value = PaymentType.online;
    _checkedRules.value = false;
    _waiting.safeValue = true;
  }

  final _repository = Repository.getInstance();

  String? discountCode;
  Price? _discountInfo;
  PackageItem? _packageItem;
  Package? _packageItemNew;
  Package? _serviceSelected;
  List<Package> _list = [];
  List<ServicePackage> _services = [];
  late String _path;
  bool _checkLatestInvoice = false;
  String? _messageErrorCode;
  final _waiting = BehaviorSubject<bool>();
  final _refreshPackages = BehaviorSubject<bool>();
  final _wrongDisCode = BehaviorSubject<bool>();
  final _discountLoading = BehaviorSubject<bool>();
  final _usedDiscount = BehaviorSubject<bool>();
  final _online = BehaviorSubject<bool>();
  final _enterDiscount = BehaviorSubject<bool>();
  final _selectedPayment = BehaviorSubject<PaymentType>();
  final _checkedRules = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _popDialog = LiveEvent();
  final _showServerError = LiveEvent();
  final _onlinePayment = LiveEvent();

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get refreshPackages => _refreshPackages.stream;

  Stream<bool> get wrongDisCode => _wrongDisCode.stream;

  Stream<bool> get discountLoading => _discountLoading.stream;

  Stream<bool> get usedDiscount => _usedDiscount.stream;

  Stream<bool> get enterDiscount => _enterDiscount.stream;

  Stream<PaymentType> get selectedPayment => _selectedPayment.stream;

  Stream<bool> get checkedRules => _checkedRules.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get popDialog => _popDialog.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get onlinePayment => _onlinePayment.stream;

  bool get isUsedDiscount => _usedDiscount.valueOrNull ?? false;

  bool get isWrongDisCode => _wrongDisCode.valueOrNull ?? false;

  PaymentType get type => _selectedPayment.value;

  Price? get discountInfo => _discountInfo;

  PackageItem? get packageItem => _packageItem;

  Package? get packageItemNew => _packageItemNew;

  Package? get serviceSelected => _serviceSelected;

  List<Package> get packageItems => _list;

  List<ServicePackage> get services => _services;

  String? get messageErrorCode => _messageErrorCode;

  String get path => _path;

  bool get checkLatestInvoice => _checkLatestInvoice;

  set setEnterDiscount(bool val) => _enterDiscount.value = val;

  set setUsedDiscount(bool val) => _usedDiscount.value = val;

  set onPaymentTap(PaymentType type) => _selectedPayment.value = type;

  set setCheckedRules(bool check) => _checkedRules.value = check;

  set setPackageItem(Package packageItem) {
    _list.forEach((element) {
      element.isSelected = false;
    });
    _packageItemNew = packageItem;
    _services = packageItem.servicesPackages ?? [];
    _packageItemNew!.isSelected = true;
    _refreshPackages.safeValue = true;
  }

  void setServiceSelected(ServicePackage packageItem) {
    if (packageItem.isSelected == null || !packageItem.isSelected!)
      packageItem.isSelected = true;
    else
      packageItem.isSelected = false;
    changePayment();
  }

  void changePayment() {
    _packageItemNew!.price!.totalPrice = _packageItemNew!.price!.finalPrice!;
    _services.forEach((element) {
      if (element.isSelected == true) {
        _packageItemNew!.price!.totalPrice =
            _packageItemNew!.price!.totalPrice! + element.price!.price!;
      }
    });
    _refreshPackages.safeValue = true;
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
      _packageItemNew!.price!.totalPrice = _discountInfo!.finalPrice;
      _usedDiscount.value = true;
      if (_discountInfo!.finalPrice == 0) {
        onPaymentTap = PaymentType.online;
      }
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

  void getPackagePayment() {
    _waiting.safeValue = true;

    _repository.getPackages().then((value) {
      _list.addAll(value.data!.items!);
      for (int i = 0; i < _list.length; i++) {
        _list[i].index = i;
        _list[i].price!.totalPrice = _list[i].price!.finalPrice;
      }
    }).whenComplete(() {
      _waiting.safeValue = false;
    });
  }

  void getReservePackagePayment() {
    _waiting.safeValue = true;
    _repository.getReservePackageUser().then((value) {
      //   _packageItem = value.data;
      _packageItem!.index = 0;
    }).whenComplete(() {
      _waiting.safeValue = false;
    });
  }

  void getPackage() {
    _waiting.safeValue = true;
    _repository.getPackagesList().then((value) {
      // _list = value.data!.items!;
      for (int i = 0; i < _list.length; i++) {
        _list[i].index = i;
      }
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
      payment.paymentTypeId = (discountInfo != null && discountInfo!.finalPrice == 0)
          ? 2
          : type == PaymentType.online
              ? 0
              : 1;
      payment.coupon = discountCode;
      payment.packageId = packageItem!.id!;
      _repository.setPaymentType(payment).then((value) {
        _navigateTo.fire(value);
      }).whenComplete(() {
        _popDialog.fire(false);
      });
    }
  }

  void selectUserPaymentSubscription() {
    if (!isUsedDiscount && (discountCode != null && discountCode!.trim().isNotEmpty)) {
      _showServerError.fireMessage('error');
    } else {
      Payment payment = new Payment();
      payment.originId = kIsWeb
          ? 0
          : Device.get().isIos
              ? 2
              : 3;
      payment.paymentTypeId = (discountInfo != null && discountInfo!.finalPrice == 0)
          ? 2
          : type == PaymentType.online
              ? 0
              : 1;
      payment.coupon = discountCode;
      payment.packageId = packageItem!.id!;
      _repository.setPaymentTypeReservePackage(payment).then((value) {
        _navigateTo.fire(value);
      }).whenComplete(() => _popDialog.fire(false));
    }
  }

  void checkOnlinePayment() {
    _repository.latestInvoice().then((value) {
      _onlinePayment.fire(value.data!.success);
      _path = value.next ?? '';
    }).whenComplete(() => _popDialog.fire(true));
  }

  void mustCheckLastInvoice() {
    _checkLatestInvoice = true;
  }

  void setMessageErrorCode(String error) {
    _messageErrorCode = error;
  }

  void dispose() {
    _discountLoading.close();
    _usedDiscount.close();
    _wrongDisCode.close();
    _online.close();
    _selectedPayment.close();
    _enterDiscount.close();
    _checkedRules.close();
    _showServerError.close();
    _navigateTo.close();
    _onlinePayment.close();
    _popDialog.close();
    _refreshPackages.close();
  }
}
