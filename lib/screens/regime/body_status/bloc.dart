import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/routes.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

enum HelpPage { regimeType, menuType, packageType, fasting }

class BodyStatusBloc {
  BodyStatusBloc();

  final _repository = Repository.getInstance();
  late PhysicalInfoData _physicalInfoData;
  final _waiting = BehaviorSubject<bool>();
  final _dietTypeList = BehaviorSubject<List<DietType>>();
  final _helpers = BehaviorSubject<List<Help>>();
  final _helpTitle = BehaviorSubject<String>();
  final _helpMedia = BehaviorSubject<List<Help>>();
  final _help = BehaviorSubject<Help>();
  final _status = BehaviorSubject<BodyStatus>();
  final _physicalInfo = BehaviorSubject<PhysicalInfoData>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<DietType>> get dietTypeList => _dietTypeList.stream;

  Stream<List<Help>> get helpers => _helpers.stream;

  Stream<Help> get help => _help.stream;

  Stream<String> get helpTitle => _helpTitle.stream;

  Stream<List<Help>> get helpMedia => _helpMedia.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream<PhysicalInfoData> get physicalInfo => _physicalInfo.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;

  BodyStatus get bodyStatus => _status.value;

  void getUserAllowedDietType() {
    _waiting.safeValue = true;
    _repository.getUserAllowedDietType().then((value) {
      _dietTypeList.safeValue = value.data!;
    }).whenComplete(() => getStatus());
  }

  void getStatus() {
    _repository.getStatus().then((value) {
      _status.safeValue = value.data!;
    }).whenComplete(() => physicalInfoData());
  }

  void physicalInfoData() {
    _repository
        .physicalInfo()
        .then((value) {
          _physicalInfo.safeValue = value.data!;
        })
        .catchError((e) => debugPrint('error error $e'))
        .whenComplete(() => _waiting.safeValue = false);
  }

  void sendInfo(PhysicalInfoData info) async {
    _repository.sendInfo(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((err) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(true);
    });
  }

  void nextStep() async {
    _repository.nextStep().then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((e) => _showServerError.fire(e));
  }

  void sendVisit(PhysicalInfoData info) async {
    _repository.visit(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((err) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(true);
    });
  }

  void sendWeight(PhysicalInfoData info) async {
    _repository.editVisit(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((err) {
      if (!MemoryApp.isNetworkAlertShown) _showServerError.fire(true);
    });
  }

  void setPhysicalInfo({required PhysicalInfoData data}) {
    _physicalInfoData = data;
  }

  void sendRequest() {
    if (navigator.currentConfiguration!.path == '/list${Routes.weightEnter}')
      sendVisit(_physicalInfoData);
    else if (navigator.currentConfiguration!.path == '/renew/weight')
      sendWeight(_physicalInfoData);
    else
      sendInfo(_physicalInfoData);
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _dietTypeList.close();
    _waiting.close();
    _physicalInfo.close();
    _helpers.close();
    _helpTitle.close();
  }
}
