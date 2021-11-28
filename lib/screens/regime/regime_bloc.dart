import 'dart:async';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';

enum HelpPage{
  regimeType,
  menuType,
}
class RegimeBloc {
  RegimeBloc() {
    regimeTypeMethod();
  }

  final _repository = Repository.getInstance();

  late String _path;
  late String _name;
  final _waiting = BehaviorSubject<bool>();
  final _itemsList = BehaviorSubject<List<RegimeType>>();
  final _helpers = BehaviorSubject<List<Help>>();
  final _helpTitle = BehaviorSubject<String>();
  final _status = BehaviorSubject<BodyStatus>();
  final _physicalInfo = BehaviorSubject<PhysicalInfoData>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  String get name => _name;

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<RegimeType>> get itemList => _itemsList.stream;

  Stream<List<Help>> get helpers => _helpers.stream;

  Stream<String> get helpTitle => _helpTitle.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream<PhysicalInfoData> get physicalInfo => _physicalInfo.stream;

  Stream get navigateToVerify => _navigateToVerify.stream;

  Stream get showServerError => _showServerError.stream;

  void regimeTypeMethod() async {
    _waiting.value = true;
    _repository.regimeType().then((value) {
      _itemsList.value = value.data!.items!;
    }).whenComplete(() => _waiting.value = false);
  }

  void physicalInfoData() async {
    _waiting.value = true;
    _repository.physicalInfo().then((value) {
      _physicalInfo.value = value.data!;
    }).whenComplete(() => _waiting.value = false);
  }

  void helpMethod(int id) async {
    _waiting.value = true;
    _repository.helpDietType(id).then((value) {
      _helpers.value = value.data!.helpers!;
      _helpTitle.value = value.requireData.name!;
    }).whenComplete(() => _waiting.value = false);
  }

  void helpBodyState(int id) async {
    _waiting.value = true;
    _repository.helpBodyState(id).then((value) {
      _name = value.data!.name!;
      _helpers.value = value.data!.helpers!;
    }).whenComplete(() => _waiting.value = false);
  }

  void pathMethod(RegimeType regime) async {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.dietTypeId = int.parse(regime.id.toString());
    _repository.setCondition(requestData).then((value) {
      _path = value.next!;
      _navigateToVerify.fire(regime);
    }).whenComplete(() => _waiting.value = false);
  }

  void sendInfo(PhysicalInfoData info) async {
    _repository.sendInfo(info).then((value) {
      _navigateToVerify.fire(value.next);
    });
  }

  void getStatus() async {
    _waiting.value = true;
    _repository.getStatus().then((value) {
      _status.value = value.data!;
    }).whenComplete(() => _waiting.value = false);
  }

  void nextStep() async {
    _repository.nextStep().then((value) {
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
