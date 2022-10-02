import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/diet_preferences.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';
import 'package:behandam/extensions/stream.dart';

import '../../../data/entity/regime/user_sickness.dart';

class CompleteInformationBloc {
  CompleteInformationBloc() {
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  int pregnancyWeek = 25;
  final _waiting = BehaviorSubject<bool>();

  final _dietPreferences = BehaviorSubject<DietPreferences>();
  final _selectedActivityLevel = BehaviorSubject<ActivityData?>();
  final _selectedGoal = BehaviorSubject<DietGoal?>();
  final _selectedDietHistory = BehaviorSubject<DietHistory?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popDialog = LiveEvent();

  String get path => _path;

  Stream<DietPreferences> get dietPreferences => _dietPreferences.stream;

  Stream<ActivityData?> get selectedActivityLevel => _selectedActivityLevel.stream;

  ActivityData? get selectedActivity => _selectedActivityLevel.stream.valueOrNull;

  Stream<DietGoal?> get selectedGoal => _selectedGoal.stream;

  DietGoal? get selectedGoalValue => _selectedGoal.stream.valueOrNull;

  Stream<DietHistory?> get selectedDietHistory => _selectedDietHistory.stream;

  DietHistory? get selectedDietHistoryValue => _selectedDietHistory.stream.valueOrNull;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get popDialog => _popDialog.stream;

  void getDietPreferences() {
    _waiting.safeValue = true;
    _repository.getDietPreferences().then((value) {
      _dietPreferences.safeValue = value.data!;
      debugPrint('repository ${_dietPreferences.value}');
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

  void updateDietPreferences() {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.activityLevelId = _selectedActivityLevel.value!.id;
    requestData.dietHistoryId = _selectedDietHistory.value!.id;
    requestData.dietGoalId = _selectedGoal.value!.id;
    if (_dietPreferences.value.hasPregnancyDiet!) {
      requestData.pregnancyWeekNumber = pregnancyWeek;
    }

    _repository.setCondition(requestData).then((value) {
      debugPrint('bloc condition ${value.data}');
      if (value.data != null) _navigateTo.fire(value.next);
    }).whenComplete(() => _popDialog.fire(true));
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _popDialog.close();
    _waiting.close();
    _selectedActivityLevel.close();
    _selectedGoal.close();
    _dietPreferences.close();
    _selectedDietHistory.close();
  }
}
