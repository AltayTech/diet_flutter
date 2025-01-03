import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';


class ActivityBloc {
  ActivityBloc(){
    loadContent();
  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _activityLevel = BehaviorSubject<ActivityLevelData>();
  final _selectedActivityLevel = BehaviorSubject<ActivityData?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<ActivityLevelData> get activityLevel => _activityLevel.stream;

  Stream<ActivityData?> get selectedActivityLevel => _selectedActivityLevel.stream;
  ActivityData? get selectedActivity => _selectedActivityLevel.stream.valueOrNull;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.activityLevel().then((value) {
      _activityLevel.value = value.requireData;
      debugPrint('repository ${_activityLevel.value}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void onActivityLevelClick(ActivityData activityLevel){
    _selectedActivityLevel.value = activityLevel;
  }

  void condition(){
      _loadingContent.safeValue = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.activityLevelId = _selectedActivityLevel.value!.id;
      _repository.setCondition(requestData).then((value) {
        debugPrint('bloc condition ${value.data}');
        if(value.data != null) _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void onRetryAfterNoInternet() {
    setRepository();
  }

  void onRetryLoadingPage() {
    setRepository();
    loadContent();
  }

  void dispose() {
    _loadingContent.close();
    _activityLevel.close();
    _selectedActivityLevel.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
