import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class TargetWeightBloc {
  TargetWeightBloc() {
    _targetWeight();
  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _targetWeightData = BehaviorSubject<TargetWeight>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<TargetWeight> get targetWeightData => _targetWeightData.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  String? get path => _path;

  String? _path;
  PhysicalInfoData? _physicalInfoData;

  void _targetWeight() {
    _loadingContent.safeValue = true;
    _repository
        .targetWeight()
        .then((value) {
          _targetWeightData.value = value.data!;
          if (_targetWeightData.value.askToChangeTargetWeight!) {
            _physicalInfo();
          }
          _path = value.next;
          debugPrint('repository ${_targetWeightData.value}');
        })
        .catchError((onError) {
      debugPrint('repository err ${onError}');
    })
        .whenComplete(() => _loadingContent.safeValue = false);
  }

  void _physicalInfo() {
    _repository.physicalInfo().then((value) {
      _physicalInfoData = value.data!;
      debugPrint('repository ${_physicalInfoData}');
    }).whenComplete(() => null);
  }

  void sendVisit() {
    _loadingContent.safeValue = true;
    _repository.visit(_physicalInfoData!).then((value) {
      _navigateTo.fire(value.next);
    }).catchError((err) {
      _showServerError.fire(true);
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryLoadingPage(){
    setRepository();
    _targetWeight();
  }

  void dispose() {
    _loadingContent.close();
    _targetWeightData.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
