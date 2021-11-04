import 'dart:async';

import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

class LoginRegisterBloc {
  LoginRegisterBloc() {
    fetchCountries();
  }

  final _repository = Repository.getInstance();

  late CountryCode _subject;
  late List<CountryCode> countries;
  final _subjectList = BehaviorSubject<List<CountryCode>>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  CountryCode get subject => _subject;

  Stream<List<CountryCode>> get subjectList => _subjectList.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;

  void fetchCountries() async {
    _repository.country().then((value) {
      _subjectList.value = value.data!;
      countries = value.data!;
      value.data!.forEach((element) {
        if (element.code == "98") {
          _subject = element;
        }
      });
    });
  }

  void loginMethod(String phoneNumber) async {
    _repository.status(phoneNumber).then((value) {
      _navigateToVerify.fire(value.data!.isExist!);
      print('value: ${value.data!.isExist}');
    });
  }

  void passwordMethod(String mobile, String pass) async {
    _repository.signIn(mobile, pass).then((value) {
      _navigateToVerify.fire(true);
    });
  }

  void registerMethod(Register register) async {
    _repository.register(register).then((value) {
      _navigateToVerify.fire(true);
    });
  }

  void sendMethod(String mobile) async {
    _repository.verificationCode(mobile);
  }

  void verifyMethod(String mobile, String code) async {
    _repository.verify(mobile, code).then((value) {
      _navigateToVerify.fire(value.data!.verified);
    });
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();

    //  _isPlay.close();
  }
}
