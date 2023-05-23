import 'dart:async';

import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/entity/auth/user_crm.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/string.dart';
import 'package:behandam/routes.dart';
import 'package:rxdart/rxdart.dart';
import 'package:country_calling_code_picker/picker.dart' as picker;
import '../../base/live_event.dart';
import '../../base/repository.dart';

class AuthenticationBloc {
  AuthenticationBloc() {
    //fetchCountries();
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();
  final _repositoryCrm = Repository.getInstanceCrm();

  final _waiting = BehaviorSubject<bool>();
  final _countries = BehaviorSubject<List<Country>>();
  final _selectedCountry = BehaviorSubject<Country>();
  final _navigateToVerify = LiveEvent();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _filterListCountry = BehaviorSubject<List<Country>>();
  final _flag = BehaviorSubject<bool>();

  List<Country> get countries {
    if (_search.isNullOrEmpty)
      return _countries.value;
    else
      return _countries.value
          .where((element) => element.name!.contains(_search!) || element.code!.contains(_search!))
          .toList();
  }

  Stream<bool> get flag => _flag.stream;

  Stream<List<Country>> get filterListCountry => _filterListCountry.stream;

  Stream get countriesStream => _countries.stream;

  Stream<Country> get selectedCountry => _selectedCountry.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  String? _search;

  late List<picker.Country> _listCountry;

  void setListCountry(List<picker.Country> list) {
    _listCountry = list;
  }

  void fetchCountries() {
    if (MemoryApp.countries == null) {
      _repository.country().then((value) async {
        _countries.value = value.data!;
        MemoryApp.countries = _countries.valueOrNull;
        setFlagToCountry();
        _filterListCountry.value = _countries.value;
        selectDefaultCountry();
      });
    } else {
      _countries.value = MemoryApp.countries!;
      _filterListCountry.value = _countries.value;
      setFlagToCountry();
      selectDefaultCountry();
    }
  }

  Country findCountryByIp(String countryFlag) {
    Country c;
    c = _countries.value.where((country) => country.isoCode!.contains(countryFlag)).toList().first;
    return c;
  }

  void selectDefaultCountry() {
    _countries.value.forEach((element) {
      if (element.code == "971") {
        _selectedCountry.value = element;
      }
    });
  }

  void setFlagToCountry() {
    if (_listCountry != null)
      _countries.value.forEach((country) {
        _listCountry.forEach((flagCountry) {
          if (country.isoCode == flagCountry.countryCode) {
            country.flag = flagCountry.flag;
          }
        });
      });
  }

  void setCountry(Country value) {
    _selectedCountry.value = value;
  }

  void loginMethod(String phoneNumber) {
    _repository.status(phoneNumber).then((value) {
      if (value.next!.contains('verify') || value.next!.contains('register')) {
        UserCrm userCrm = UserCrm();
        userCrm.mobile = phoneNumber;
        userCrm.repository = 27;
        // diet topic
        userCrm.topic = 21;
        _repositoryCrm.sendUserToCrm(userCrm).then((value) {

        }).whenComplete(() {
          _navigateTo.fire(true);
        });
      } else {
        _navigateToVerify.fire(value.next);
      }
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
    }).catchError((onError) {
      _showServerError.fire(false);
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
      /* MemoryApp.analytics!.logEvent(name: "register_success");*/
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _waiting.value = false;
        _navigateToVerify.fire(value.next);
      });
    }).catchError((onError) {
      _showServerError.fire(false);
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
      /*MemoryApp.analytics!.logEvent(name: "register_success");*/
      _repository
          .getUser()
          .then((value) => MemoryApp.userInformation = value.data)
          .whenComplete(() {
        _waiting.value = false;
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
    if (text.trim().isEmpty || text.trim().length == 0)
      _filterListCountry.value = _countries.value;
    else
      _filterListCountry.value = _countries.value
          .where((country) =>
              country.name!.toLowerCase().contains(text.toLowerCase()) ||
              country.code!.contains(text))
          .toList();
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _countries.close();
    _waiting.close();
    _navigateTo.close();
  }
}
