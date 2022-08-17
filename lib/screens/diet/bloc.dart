import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/screens/authentication/register.dart';
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

  String? date;

  Stream<bool> get loadingContent => _loadingContent.stream;
  Stream<PhysicalInfoData> get physicalInfoData => _physicalInfoData.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  late PhysicalInfoData _physicalInfo;

  void physicalInfo() {

    _physicalInfo=PhysicalInfoData();
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

  void setGender(GenderType gender){
    _physicalInfo.gender=gender;
    _physicalInfoData.safeValue=_physicalInfo;
  }

  void dispose() {
    _loadingContent.close();

    _navigateTo.close();
    _showServerError.close();
  }
}
