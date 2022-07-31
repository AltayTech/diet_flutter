import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PhysicalInfoBloc {
  PhysicalInfoBloc() {

  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _physicalInfoData = BehaviorSubject<PhysicalInfoData>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream<PhysicalInfoData> get physicalInfoData => _physicalInfoData.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  late PhysicalInfoData _physicalInfo;

  void physicalInfo() {

    _physicalInfo=PhysicalInfoData();
    _physicalInfo.gender=GenderType.Male;
    _physicalInfo.height=170;
    _physicalInfo.weight=55.0;
    _physicalInfo.kilo=55;
    _physicalInfo.gram=5;
    _physicalInfo.age=25;
    _physicalInfo.birthDate="1993-10-20";
    _physicalInfoData.safeValue=_physicalInfo;

/*  _repository.physicalInfo().then((value) {
      _physicalInfoData = value.data!;
      debugPrint('repository ${_physicalInfoData}');
    }).whenComplete(() => null);*/
  }

/*
  void sendVisit() {
    _loadingContent.safeValue = true;
    _repository.visit(_physicalInfoData!).then((value) {
      _navigateTo.fire(value.next);
    }).catchError((err) {
      _showServerError.fire(true);
    }).whenComplete(() => _loadingContent.safeValue = false);
  }
*/

  void dispose() {
    _loadingContent.close();

    _navigateTo.close();
    _showServerError.close();
  }
}
