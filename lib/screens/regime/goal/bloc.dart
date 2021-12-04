import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

class DietGoalBloc {
  DietGoalBloc() {
    _loadContent();
  }

  final _repository = Repository.getInstance();
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

  void _loadContent() {
    _loadingContent.value = true;
    _repository.dietGoals().then((value) {
      _dietGoals.value = value.requireData;
      debugPrint('repository ${_dietGoals.value}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onDietHistoryClick(DietGoal goal) {
    _selectedGoal.value = goal;
  }

  void condition() {
    if (_selectedGoal.valueOrNull != null) {
      _loadingContent.value = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.dietGoalId = _selectedGoal.value!.id;
      debugPrint('bloc condition ${requestData.toJson()}');
      _repository.setCondition(requestData).then((value) {
        debugPrint('bloc condition ${value.data}');
        if(value.data != null) _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.value = false);
    }
  }

  void dispose() {
    _loadingContent.close();
    _dietGoals.close();
    _selectedGoal.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
