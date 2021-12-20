import 'dart:async';

import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/string.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class AuthenticationBloc {
  AuthenticationBloc() {
    fetchCountries();
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  final _waiting = BehaviorSubject<bool>();
  final _countries = BehaviorSubject<List<Country>>();
  final _selectedCountry = BehaviorSubject<Country>();
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

  Stream<Country> get selectedCountry => _selectedCountry.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  String? _search;

  void fetchCountries() {
    if (MemoryApp.countries == null) {
      _repository.country().then((value) {
        MemoryApp.countries = value.data!;
        _countries.value = value.data!;
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
          _selectedCountry.value = element;
        }
      });
    }
  }

  void setCountry(Country value) {
    _selectedCountry.value = value;
  }

  void loginMethod(String phoneNumber) {
    _repository.status(phoneNumber).then((value) {
      _navigateToVerify.fire(value.next);
      print('value: ${value.data!.isExist}');
    }).whenComplete(() => _showServerError.fire(false));
  }

  void passwordMethod(User user) {
    _repository.signIn(user).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      print('pass token ${value.next} / ${await AppSharedPreferences.authToken}');
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _showServerError.fire(false);
        _navigateToVerify.fire(value.next);
      });
    });
  }

  void resetPasswordMethod(Reset pass) {
    _waiting.value = true;
    _repository.reset(pass).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _waiting.value = false);
  }

  void registerMethod(Register register) {
    _waiting.value = true;
    _repository.register(register).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.analytics!.logEvent(name: "register_success");
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _waiting.value = false;
        _navigateToVerify.fire(value.next);
      });
    });
  }

  void sendCodeMethod(String mobile) {
    _waiting.value = true;
    _repository
        .verificationCode(mobile)
        .then((value) => _navigateToVerify.fire(value.next))
        .whenComplete(() {
      _waiting.value = false;
      MemoryApp.forgetPass = false;
    });
  }

  void tryCodeMethod(String mobile) {
    _repository.verificationCode(mobile);
  }

  void verifyMethod(VerificationCode verify) {
    _repository.verify(verify).then((value) async {
      if (value.data!.token != null)
        await AppSharedPreferences.setAuthToken(value.data!.token!.accessToken);
      _navigateToVerify.fire(value.next);
    }).whenComplete(() {
      _showServerError.fire(true);
    });
  }

  void landingReg(Register register) {
    _waiting.value = true;
    _repository.landingReg(register).then((value) async {
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.token = value.requireData.token;
      MemoryApp.analytics!.logEvent(name: "register_success");
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _waiting.value = false;
        _navigateToVerify.fire(value.next);
      });
    });
  }

  void onCountrySearch(String search) {
    _search = search;
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _countries.close();
    _waiting.close();
    _navigateTo.close();
  }
}
