import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/daily_message.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class BodyStatusBloc {
  BodyStatusBloc();

  Repository _repository = Repository.getInstance();
  late PhysicalInfoData _physicalInfoData;
  final _waiting = BehaviorSubject<bool>();
  final _dietTypeList = BehaviorSubject<List<DietType>>();
  final _template = BehaviorSubject<TempTicket?>();
  final _dietSelected = BehaviorSubject<DietType?>();
  final _status = BehaviorSubject<BodyStatus>();
  final _physicalInfo = BehaviorSubject<PhysicalInfoData>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popDialog = LiveEvent();

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<DietType>> get dietTypeList => _dietTypeList.stream;

  Stream<TempTicket?> get template => _template.stream;

  Stream<DietType?> get dietSelected => _dietSelected.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream<PhysicalInfoData> get physicalInfo => _physicalInfo.stream;

  Stream get navigateToVerify => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get popDialog => _popDialog.stream;

  BodyStatus get bodyStatus => _status.value;

  get getDietSelected => _dietSelected.value;

  set setDietSelected(DietType dietType) => _dietSelected.safeValue = dietType;

  void getUserAllowedDietType() {
    _waiting.safeValue = true;
    _repository.getUserAllowedDietType().then((value) {
      _dietTypeList.safeValue = value.data!.dietTypes!;
      _template.safeValue = value.data!.template ?? TempTicket();
      _dietSelected.safeValue = value.data?.dietTypes![0] ?? null;
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
        .whenComplete(() => _waiting.safeValue = false);
  }

  void updateDietType() {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.dietTypeId = _dietSelected.value!.id;
    _repository.setCondition(requestData).then((value) {
      debugPrint('bloc updateDietType ${value.data}');
      if (value.data != null) _navigateTo.fire(value.next);
    }).whenComplete(() => _popDialog.fire(true));
  }

  void nextStep() {
    _repository.nextStep().then((value) {
      _navigateTo.fire(value.next);
    }).catchError((e) => _showServerError.fire(e));
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryAfterNoInternet() {
    setRepository();
  }

  void onRetryLoadingPage() {
    setRepository();
    getUserAllowedDietType();
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _popDialog.close();
    _dietTypeList.close();
    _template.close();
    _dietSelected.close();
    _waiting.close();
    _physicalInfo.close();
  }
}
