import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/sickness.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:behandam/extensions/stream.dart';

class CompleteInformationBloc {
  CompleteInformationBloc() {
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  final _waiting = BehaviorSubject<bool>();

  final _userSickness = BehaviorSubject<List<Sickness>>();
  final _activityLevel = BehaviorSubject<ActivityLevelData>();
  final _selectedActivityLevel = BehaviorSubject<ActivityData?>();
  final _dietGoals = BehaviorSubject<DietGoalData>();
  final _selectedGoal = BehaviorSubject<DietGoal?>();
  final _dietHistory = BehaviorSubject<DietHistoryData>();
  final _selectedDietHistory = BehaviorSubject<DietHistory?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  Stream<ActivityLevelData> get activityLevel => _activityLevel.stream;

  Stream<ActivityData?> get selectedActivityLevel =>
      _selectedActivityLevel.stream;

  ActivityData? get selectedActivity =>
      _selectedActivityLevel.stream.valueOrNull;

  Stream<DietGoalData> get dietGoals => _dietGoals.stream;

  Stream<DietGoal?> get selectedGoal => _selectedGoal.stream;

  DietGoal? get selectedGoalValue => _selectedGoal.stream.valueOrNull;

  Stream<DietHistoryData> get dietHistory => _dietHistory.stream;

  Stream<DietHistory?> get selectedDietHistory => _selectedDietHistory.stream;

  DietHistory? get selectedDietHistoryValue =>
      _selectedDietHistory.stream.valueOrNull;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void getActivities() {
    _waiting.safeValue = true;
    _repository.activityLevel().then((value) {
      _activityLevel.value = value.requireData;
      debugPrint('repository ${_activityLevel.value}');
    }).whenComplete(() => getDietGoalData());
  }

  void getDietGoalData() {
    _repository.dietGoals().then((value) {
      _dietGoals.value = value.requireData;
      debugPrint('repository ${_dietGoals.value}');
    }).whenComplete(() => getDietHistory());
  }

  void getDietHistory() {
    _repository.dietHistory().then((value) {
      _dietHistory.value = value.requireData;
      debugPrint('repository ${_dietHistory.value}');
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void onActivityLevelClick(ActivityData activityLevel) {
    _selectedActivityLevel.value = activityLevel;
  }

  void onDietGoalClick(DietGoal goal) {
    _selectedGoal.value = goal;
  }

  void onDietHistoryClick(DietHistory dietHistory) {
    _selectedDietHistory.value = dietHistory;
  }

  void condition() {
    _waiting.safeValue = true;
    ConditionRequestData requestData = ConditionRequestData();
    requestData.activityLevelId = _selectedActivityLevel.value!.id;
    _repository.setCondition(requestData).then((value) {
      debugPrint('bloc condition ${value.data}');
      if (value.data != null) _navigateTo.fire(value.next);
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
    _userSickness.close();
    _activityLevel.close();
    _selectedActivityLevel.close();
    _dietGoals.close();
    _selectedGoal.close();
    _dietHistory.close();
    _selectedDietHistory.close();
  }
}
