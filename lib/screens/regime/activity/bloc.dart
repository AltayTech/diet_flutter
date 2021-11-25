import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class ActivityBloc {
  ActivityBloc(){
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _activityLevel = BehaviorSubject<ActivityLevelData>();
  final _selectedActivityLevel = BehaviorSubject<ActivityData?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<ActivityLevelData> get activityLevel => _activityLevel.stream;

  Stream<ActivityData?> get selectedActivityLevel => _selectedActivityLevel.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.activityLevel().then((value) {
      _activityLevel.value = value.requireData;
      debugPrint('repository ${_activityLevel.value}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onActivityLevelClick(ActivityData activityLevel){
    _selectedActivityLevel.value = activityLevel;
  }

  void condition(){
    if(_selectedActivityLevel.valueOrNull != null){
      _loadingContent.value = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.activityLevelId = _selectedActivityLevel.value!.id;
      _repository.setCondition(requestData).then((value) {
        debugPrint('bloc condition ${value.data}');
        if(value.data != null) _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.value = false);
    }
  }

  void dispose() {
    _loadingContent.close();
    _activityLevel.close();
    _selectedActivityLevel.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
