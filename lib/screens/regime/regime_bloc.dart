import 'dart:async';

import 'package:behandam/app/app.dart';
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

import '../../base/live_event.dart';
import '../../base/repository.dart';

enum HelpPage { regimeType, menuType, packageType, fasting }

class RegimeBloc {
  RegimeBloc();

  Repository _repository = Repository.getInstance();
  late PhysicalInfoData _physicalInfoData;
  late String _path;
  late String _name;
  final _waiting = BehaviorSubject<bool>();
  final _itemsList = BehaviorSubject<List<RegimeType>>();
  final _helpers = BehaviorSubject<List<Help>>();
  final _helpTitle = BehaviorSubject<String>();
  final _helpMedia = BehaviorSubject<List<Help>>();
  final _help = BehaviorSubject<Help>();
  final _status = BehaviorSubject<BodyStatus>();
  final _physicalInfo = BehaviorSubject<PhysicalInfoData>();
  final _navigateToVerify = LiveEvent();
  final _popLoading = LiveEvent();

  String get path => _path;

  String get name => _name;

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<RegimeType>> get itemList => _itemsList.stream;

  Stream<List<Help>> get helpers => _helpers.stream;

  Stream<Help> get help => _help.stream;

  Stream<String> get helpTitle => _helpTitle.stream;

  Stream<List<Help>> get helpMedia => _helpMedia.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream<PhysicalInfoData> get physicalInfo => _physicalInfo.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get popLoading => _popLoading.stream;

  BodyStatus get bodyStatus => _status.value;

  void regimeTypeMethod() async {
    _waiting.safeValue = true;
    _repository.regimeType().then((value) {
      _itemsList.value = value.data!.items!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void physicalInfoData() async {
    _waiting.safeValue = true;
    _repository
        .physicalInfo()
        .then((value) {
          _physicalInfo.value = value.data!;
        })
        .catchError((e) => debugPrint('error error $e'))
        .whenComplete(() => _waiting.safeValue = false);
  }

  void helpMethod(int id) async {
    _waiting.safeValue = true;
    _repository.helpDietType(id).then((value) {
      _help.value = value.data!;
      _helpers.value = value.data!.helpers!;
      _helpTitle.value = value.requireData.name!;
      _helpMedia.value = value.requireData.media!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void helpBodyState(int id) async {
    _waiting.safeValue = true;
    _repository.helpBodyState(id).then((value) {
      _name = value.data!.name!;
      _helpers.value = value.data!.helpers!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void pathMethod(RegimeType regime) async {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.dietTypeId = int.parse(regime.id.toString());
    _repository.setCondition(requestData).then((value) {
      _path = value.next!;
      _navigateToVerify.fire(regime);
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) {
        _popLoading.fire(true);
        _waiting.safeValue = false;
      }
    });
  }

  void sendInfo(PhysicalInfoData info) async {
    _repository.sendInfo(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _popLoading.fire(true);
    });
  }

  void getStatus() async {
    _waiting.safeValue = true;
    _repository.getStatus().then((value) {
      _status.value = value.data!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void nextStep() async {
    _repository.nextStep().then((value) {
      _navigateToVerify.fire(value.next);
    }).whenComplete(() => _popLoading.fire(true));
  }

  void sendVisit(PhysicalInfoData info) async {
    _repository.visit(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _popLoading.fire(true);
    });
  }

  void sendWeight(PhysicalInfoData info) async {
    _repository.editVisit(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _popLoading.fire(true);
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

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _popLoading.close();
    _navigateToVerify.close();
    _itemsList.close();
    _waiting.close();
    _physicalInfo.close();
    _helpers.close();
    _helpTitle.close();
  }
}
