import 'dart:async';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';
import 'package:behandam/extensions/stream.dart';
enum HelpPage{
  regimeType,
  menuType,
  packageType,
  fasting
}
class RegimeBloc {
  RegimeBloc();

  final _repository = Repository.getInstance();

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
  final _showServerError = LiveEvent();

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

  Stream get showServerError => _showServerError.stream;

  void regimeTypeMethod() async {
    _waiting.safeValue = true;
    _repository.regimeType().then((value) {
      _itemsList.value = value.data!.items!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void physicalInfoData() async {
    _waiting.safeValue = true;
    _repository.physicalInfo().then((value) {
      _physicalInfo.value = value.data!;
    }).catchError((e) => debugPrint('error error $e')).whenComplete(() => _waiting.safeValue = false);
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
      _showServerError.fire(true);
      _waiting.safeValue = false;
    });
  }

  void sendInfo(PhysicalInfoData info) async {
    _repository.sendInfo(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((onError){
      _showServerError.fire(true);
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
    }).catchError((e) => _showServerError.fire(e));
  }

  void sendVisit(PhysicalInfoData info) async {
    _repository.visit(info).then((value) {
      _navigateToVerify.fire(value.next);
    }).catchError((err){
      _showServerError.fire(true);
    });
  }
  void sendWeight(PhysicalInfoData info) async {
    _repository.editVisit(info).then((value) {
      _navigateToVerify.fire(value.next);
    });
  }
  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _itemsList.close();
    _waiting.close();
    _physicalInfo.close();
    _helpers.close();
    _helpTitle.close();
  }
}
