import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class DietGoalBloc {
  DietGoalBloc() {
    loadContent();
  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _dietGoals = BehaviorSubject<DietGoalData>();
  final _selectedGoal = BehaviorSubject<DietGoal?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<DietGoalData> get dietGoals => _dietGoals.stream;

  Stream<DietGoal?> get selectedGoal => _selectedGoal.stream;
  DietGoal? get selectedGoalValue => _selectedGoal.stream.valueOrNull;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.dietGoals().then((value) {
      _dietGoals.value = value.requireData;
      debugPrint('repository ${_dietGoals.value}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void onDietHistoryClick(DietGoal goal) {
    _selectedGoal.value = goal;
  }

  void condition() {
    if (_selectedGoal.valueOrNull != null) {
      _loadingContent.safeValue = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.dietGoalId = _selectedGoal.value!.id;
      debugPrint('bloc condition ${requestData.toJson()}');
      _repository.setCondition(requestData).then((value) {
        debugPrint('bloc condition ${value.data}');
        if(value.data != null) _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.safeValue = false);
    }
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _loadingContent.close();
    _dietGoals.close();
    _selectedGoal.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
