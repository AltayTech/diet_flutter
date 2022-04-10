import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:rxdart/rxdart.dart';

enum PaymentType {
  online,
  cardToCard
}

class HistorySubscriptionPaymentBloc {
  HistorySubscriptionPaymentBloc() {
    _discountLoading.value = false;
    _enterDiscount.value = false;
    _selectedPayment.value = PaymentType.online;
    _checkedRules.value = false;
  }

  final _repository = Repository.getInstance();

  String? discountCode;
  Price? _discountInfo;
  PackageItem? _packageItem;

  final _wrongDisCode = BehaviorSubject<bool>();
  final _discountLoading = BehaviorSubject<bool>();
  final _usedDiscount = BehaviorSubject<bool>();
  final _online = BehaviorSubject<bool>();
  final _enterDiscount = BehaviorSubject<bool>();
  final _selectedPayment = BehaviorSubject<PaymentType?>();
  final _checkedRules = BehaviorSubject<bool>();

  Stream<bool> get wrongDisCode => _wrongDisCode.stream;

  Stream<bool> get discountLoading => _discountLoading.stream;

  Stream<bool> get usedDiscount => _usedDiscount.stream;

  Stream<bool> get enterDiscount => _enterDiscount.stream;

  Stream<PaymentType?> get selectedPayment => _selectedPayment.stream;

  Stream<bool> get checkedRules => _checkedRules.stream;

  bool get isUsedDiscount => _usedDiscount.valueOrNull ?? false;

  bool get isWrongDisCode => _wrongDisCode.valueOrNull ?? false;

  Price? get discountInfo => _discountInfo;

  set setEnterDiscount(bool val) => _enterDiscount.value = val;

  set onPaymentTap(PaymentType type) => _selectedPayment.value = type;

  set setCheckedRules(bool check) => _checkedRules.value = check;

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

  void dispose() {
    _discountLoading.close();
    _usedDiscount.close();
    _wrongDisCode.close();
    _online.close();
    _selectedPayment.close();
    _enterDiscount.close();
    _checkedRules.close();
  }
}