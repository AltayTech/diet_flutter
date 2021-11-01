import 'dart:async';
import 'dart:convert';
import 'package:behandam/base/network_response.dart';
import 'package:behandam/data/entity/auth/country-code.dart';
import 'package:behandam/data/entity/auth/status.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:rxdart/rxdart.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:dio/dio.dart';

import '../../api/api.dart';
import '../../routes.dart';
import '../../base/live_event.dart';
import '../../base/repository.dart';


class ProfileBloc {
  ProfileBloc() {
    fetchUserInformation();
  }

  final _repository = Repository.getInstance();

  bool showRefund = false;
  bool showPdf = false;

  late UserInformation _userInformation;
  final _showServerError = LiveEvent();
  final _progressNetwork = BehaviorSubject<bool>();
  final _showProgressItem = BehaviorSubject<bool>();
  final _userInformationStream = BehaviorSubject<UserInformation>();

  UserInformation get userInfo => _userInformation;

  Stream get showServerError => _showServerError.stream;

  Stream<bool> get progressNetwork => _progressNetwork.stream;

  Stream<bool> get isShowProgressItem => _showProgressItem.stream;

  Stream<UserInformation> get userInformationStream => _userInformationStream.stream;

  bool? get isProgressNetwork => _progressNetwork.value;

  void fetchUserInformation() async {
    _progressNetwork.value = true;
    _repository.getUser().then((value) {
      print('value ==> ${value.data!.firstName}');
      _userInformation = value.data!;
      _userInformationStream.value = value.data!;
    }).catchError((onError) {
      print('onError ==> ${onError.toString()}');
    }).whenComplete(() {
      _progressNetwork.value = false;
    });
  }

  void getPdfMeal(FoodDietPdf type) {
    _showProgressItem.value = true;
    _repository
        .getPdfUrl(type)
        .then((value) {
      launchURL(value.data!.url!);
      // Share.share(value['data']['url'])
    }).catchError((onError) {
      _showServerError.fireMessage(onError);
    }).whenComplete(() {
      _showProgressItem.value = false;
    });
  }
    void dispose() {
      _showServerError.close();
      _progressNetwork.close();
      _showProgressItem.close();
      _userInformationStream.close();
      //  _isPlay.close();
    }
  }
