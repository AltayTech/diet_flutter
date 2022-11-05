import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/refund.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/utils/sheba.dart';
import 'package:rxdart/rxdart.dart';

class RefundBloc {
  RefundBloc() {
    _waiting.safeValue = false;
    _showPass.safeValue = false;
  }

  Repository _repository = Repository.getInstance();

  late String _path;

  final _shebaNumber = BehaviorSubject<String?>();
  final _shebaBankName = BehaviorSubject<String?>();
  final _waiting = BehaviorSubject<bool>();
  final _canRefund = BehaviorSubject<bool>();
  final _showPass = BehaviorSubject<bool>();
  final _serverError = LiveEvent();
  final _navigateTo = LiveEvent();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get canRefund => _canRefund.stream;

  bool get canRefundValue => _canRefund.stream.value;

  Stream get serverError => _serverError.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream<String?> get shebaNumber => _shebaNumber.stream;

  Stream<String?> get shebaBankName => _shebaBankName.stream;

  Stream<bool> get showPass => _showPass.stream;

  String? get shebaNumberValue => _shebaNumber.stream.valueOrNull ?? '';

  String? _date;
  String? message;
  String? password;
  String? cardOwner;

  void setShowPassword(bool value) {
    _showPass.safeValue = value;
  }

  void setDate(String date) {
    _date = date;
  }

  String get date => _date ?? '';

  void getTermPackage() {
    if (MemoryApp.termPackage == null) {
      _waiting.safeValue = true;
      _repository.getTermPackage().then((value) {
        MemoryApp.termPackage = value.data;
      }).whenComplete(() {
        getRefund();
      });
    } else {
      getRefund();
    }
  }

  void getRefund() {
    if (MemoryApp.refundItem == null) {
      _repository.getRefund().then((value) {
        MemoryApp.refundItem = value.data;
      }).whenComplete(() {
        _waiting.safeValue = false;
      });
    }
  }

  void setCanRefund(bool value) {
    _canRefund.value = value;
  }

  void verify() {
    _repository.verifyPassword(password!).then((value) {
      _navigateTo.fire(value.next);
    }).whenComplete(() {
      _serverError.fire(false);
    });
  }

  void record() {
    RefundVerify refundVerify = new RefundVerify();
    refundVerify.shebaNumber = _shebaNumber.value!.replaceAll(' ', '');
    refundVerify.cardOwner = cardOwner;
    _repository.setRefund(refundVerify).then((value) {
      MemoryApp.refundItem = null;
      MemoryApp.termPackage = null;

      _navigateTo.fire(value.next);
    }).whenComplete(() {
      _serverError.fire(false);
    });
  }

  void setCardNumber(String shebaNumber) {
    _shebaNumber.safeValue = shebaNumber;

    _shebaBankName.safeValue =
        Sheba(shebaNumberValue!.replaceAll(' ', '')).call()?.persianName ?? '';
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryAfterNoInternet() {
    setRepository();
  }

  void onRetryLoadingPage() {
    setRepository();
  }

  void dispose() {
    _waiting.close();
    _serverError.close();
    _navigateTo.close();
    _canRefund.close();
    _shebaNumber.close();
    _shebaBankName.close();
    _showPass.close();
  }
}
