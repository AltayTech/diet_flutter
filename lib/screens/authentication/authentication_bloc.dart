import 'dart:async';

import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/extensions/string.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class AuthenticationBloc {
  AuthenticationBloc() {
    _waiting.safeValue = false;
    _obscureTextPass.safeValue = false;
    _obscureTextConfirmPass.safeValue = false;
  }

  final _repository = Repository.getInstance();

  final _waiting = BehaviorSubject<bool>();
  final _flag = BehaviorSubject<bool>();
  final _start = BehaviorSubject<int>();
  final _countries = BehaviorSubject<List<Country>>();
  final _filterListCountry = BehaviorSubject<List<Country>>();
  final _selectedCountry = BehaviorSubject<Country>();
  final _obscureTextPass = BehaviorSubject<bool>();
  final _obscureTextConfirmPass = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  List<Country> get countries {
    if (_search.isNullOrEmpty)
      return _countries.value;
    else
      return _countries.value
          .where((element) => element.name!.contains(_search!) || element.code!.contains(_search!))
          .toList();
  }

  Stream get countriesStream => _countries.stream;

  Stream<List<Country>> get filterListCountry => _filterListCountry.stream;

  Stream<Country> get selectedCountry => _selectedCountry.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get obscureTextPass => _obscureTextPass.stream;

  Stream<bool> get obscureTextConfirmPass => _obscureTextConfirmPass.stream;

  Stream<bool> get flag => _flag.stream;

  Stream<int> get start => _start.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  bool get isTrySendCode => _isTrySendCode!;

  set setTrySendCode(bool isTrySendCode) => _isTrySendCode = isTrySendCode;

  set setFlag(bool flag) => _flag.value = flag;

  String? _search;

  bool? _isTrySendCode;

  Timer? _timer;

  void startTimer() {
    _start.value = 120;

    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start.value == 0) {
          _flag.value = true;
          timer.cancel();
        } else {
          _start.value--;
        }
      },
    );
  }

  void fetchCountries() {
    if (MemoryApp.countries == null) {
      _repository.country().then((value) {
        MemoryApp.countries = value.data!;
        _countries.value = value.data!;
        _filterListCountry.value = value.data!;
        value.data!.forEach((element) {
          if (element.code == "98") {
            _selectedCountry.value = element;
          }
        });
      });
    } else {
      _countries.value = MemoryApp.countries!;
      _countries.value.forEach((element) {
        if (element.code == "98") {
          _selectedCountry.safeValue = element;
        }
      });
    }
  }

  void setCountry(Country value) {
    _selectedCountry.safeValue = value;
  }

  void loginMethod(String phoneNumber) {
    _repository.status(phoneNumber).then((value) {
      _navigateToVerify.fire(value.next);
      debugPrint('value: ${value.data!.isExist}');
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(false);
    });
  }

  void passwordMethod(User user) {
    _repository.signIn(user).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      debugPrint('pass token ${value.next} / ${await AppSharedPreferences.authToken}');
      checkFcm();
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        if (!MemoryApp.isNetworkAlertShown) {
          _showServerError.fire(false);
          _navigateToVerify.fire(value.next);
        }
      });
    }).catchError((onError) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(false);
    });
  }

  void resetPasswordMethod(Reset pass) {
    _waiting.safeValue = true;
    _repository.reset(pass).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void registerMethod(Register register) {
    _waiting.safeValue = true;
    _repository.register(register).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.analytics!.logEvent(name: "register_success");
      checkFcm();
      _repository.getUser().then((value) {
        MemoryApp.userInformation = value.data;
        _navigateToVerify.fire(value.next);
      }).whenComplete(() {
        _waiting.safeValue = false;
      });
    }).catchError((onError) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(false);
    });
  }

  void sendCodeMethod(String mobile) {
    _repository
        .verificationCode(mobile)
        .then((value) => _navigateToVerify.fire(value.next))
        .whenComplete(() {
      MemoryApp.forgetPass = false;
    }).catchError((onError) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(false);
    });
  }

  void tryCodeMethod(String mobile) {
    _repository.verificationCode(mobile);
  }

  void verifyMethod(VerificationCode verify) {
    _repository.verify(verify).then((value) async {
      if (value.data!.token != null)
        await AppSharedPreferences.setAuthToken(value.data!.token!.accessToken);
      _showServerError.fire(true);
      _navigateToVerify.fire(value.next);
    }).catchError((onError) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(true);
    });
  }

  void landingReg(Register register) {
    _waiting.safeValue = true;
    _repository.landingReg(register).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.token = value.requireData.token;
      MemoryApp.analytics!.logEvent(name: "register_success");
      checkFcm();
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _waiting.safeValue = false;
        _navigateToVerify.fire(value.next);
      });
    }).catchError((onError) {
      _showServerError.fire(false);
    });
  }

  void onCountrySearch(String search) {
    _search = search;
  }

  void searchCountry(String text) {
    // search = text;
    _filterListCountry.value = _countries.value
        .where((country) =>
            country.name!.toLowerCase().contains(text.toLowerCase()) ||
            country.code!.contains(text))
        .toList();
  }

  void checkFcm() async {
    String fcm = await AppSharedPreferences.fcmToken;
    bool sendFcm = await AppSharedPreferences.sendFcmToken;
    if (fcm != 'null' && !sendFcm)
      _repository.addFcmToken(fcm).then((value) async {
        await AppSharedPreferences.setSendFcmToken(true);
      });
  }

  void setObscureTextPass() {
    _obscureTextPass.safeValue = !_obscureTextPass.value;
  }

  void setObscureTextConfirmPass() {
    _obscureTextConfirmPass.safeValue = !_obscureTextConfirmPass.value;
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _countries.close();
    _waiting.close();
    _navigateTo.close();
    _filterListCountry.close();
    if (_timer != null) _timer!.cancel();
    _flag.close();
    _start.close();
    _obscureTextPass.close();
    if (_obscureTextConfirmPass.isClosed) _obscureTextConfirmPass.close();
  }
}
