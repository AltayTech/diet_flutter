import 'dart:async';
import 'dart:convert';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/entity/auth/reset.dart';
import 'package:behandam/data/entity/auth/status.dart';
import 'package:behandam/data/entity/auth/user_info.dart';
import 'package:behandam/data/entity/auth/verify.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';

import '../../api/api.dart';
import '../../routes.dart';
import '../../base/live_event.dart';
import '../../base/repository.dart';


class AuthenticationBloc{
  AuthenticationBloc(){
    fetchCountries();
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  late CountryCode _subject;
  final _waiting = BehaviorSubject<bool>();
  final _subjectList = BehaviorSubject<List<CountryCode>>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();
  late List<CountryCode> countries;

  CountryCode get subject => _subject;
  Stream<List<CountryCode>> get subjectList => _subjectList.stream;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;


  void fetchCountries() {
   if(MemoryApp.countryCode == null) {
     _repository.country().then((value) {
       MemoryApp.countryCode = value.data!;
       _subjectList.value = value.data!;
       countries = value.data!;
       value.data!.forEach((element) {
         if (element.code == "98") {
           _subject = element;
         }
       });
     });
   }else {
     _subjectList.value = MemoryApp.countryCode!;
     countries = MemoryApp.countryCode!;
     _subjectList.value.forEach((element) {
       if (element.code == "98") {
         _subject = element;
       }
     });
   }
  }

  void loginMethod(String phoneNumber) {
    _waiting.value = true;
    MemoryApp.needRoute = true;
    _repository.status(phoneNumber).then((value) {
     _navigateToVerify.fire( value.data!.isExist!);
      print('value: ${value.data!.isExist}');
    }).whenComplete(() => _waiting.value = false);
  }

  void passwordMethod(User user) {
    _waiting.value = true;
    _repository.signIn(user).then((value) async{
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.token = value.requireData.token;
      print('pass token ${value.next} / ${await AppSharedPreferences.authToken}');
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _waiting.value = false);
  }

  void resetPasswordMethod(Reset pass) {
    _waiting.value = true;
    _repository.reset(pass).then((value) async{
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.token = value.requireData.token;
      _navigateToVerify.fire(true);
    }).whenComplete(() => _waiting.value = false);
  }

  void registerMethod(Register register){
    _waiting.value = true;
    _repository.register(register).then((value) async{
      await AppSharedPreferences.setAuthToken(value.data!.token);
      MemoryApp.token = value.requireData.token;
      MemoryApp.analytics!.logEvent(name: "register_success");
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _waiting.value = false);
  }

  void sendCodeMethod(String mobile) {
    _repository.verificationCode(mobile);
  }

  void verifyMethod(VerificationCode verify) {
    _waiting.value = true;
    _repository.verify(verify).then((value) async{
      if(value.data!.token != null)
      await AppSharedPreferences.setAuthToken(value.data!.token!.accessToken);
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _waiting.value = false);
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _subjectList.close();
    _waiting.close();
  }
}
