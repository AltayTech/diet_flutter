import 'dart:async';
import 'dart:convert';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:behandam/data/entity/auth/status.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';

import '../../api/api.dart';
import '../../routes.dart';
import '../../base/live_event.dart';
import '../../base/repository.dart';


class LoginBloc{
  LoginBloc(){
    fetchCountries();
  }

  final _repository = Repository.getInstance();

  late Country _subject;
  final _subjectList = BehaviorSubject<List<Country>>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();
  Country get subject => _subject;
  Stream<List<Country>> get subjectList => _subjectList.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;

  void loginMethod(String phoneNumber) async {
    _repository.status(phoneNumber).then((value) {
      _navigateToVerify.fire(true);
      print('value: $value');
    }).onError((error,stackTrack){
              var messageResponse;
              print("onError: $error");
              switch (error.runtimeType) {
                case DioError:
                  {
                    final res = (error as DioError).response;
                    try {
                      messageResponse = NetworkResponse<dynamic>.fromJson(res?.data,(json) => CheckStatus.fromJson(json as Map<String, dynamic>)).error!.message;
                    } on Exception catch (error) {
                      messageResponse = null;
                    }
                    break;
                  }
                default:
                  messageResponse = null;
              }
              print('messageResponse : $messageResponse');
       _showServerError.fireMessage(messageResponse);
    });
  }

  void fetchCountries() async {
   _repository.country().then((value) {
     _subjectList.value = value.data!;
     value.data!.forEach((element){
       if(element.code == "98") {
         _subject = element;
       }
     });
   });
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    //  _isPlay.close();
  }
}
