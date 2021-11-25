import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

class DietHistoryBloc {
  DietHistoryBloc() {
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _dietHistory = BehaviorSubject<DietHistoryData>();
  final _selectedDietHistory = BehaviorSubject<DietHistory?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<DietHistoryData> get dietHistory => _dietHistory.stream;

  Stream<DietHistory?> get selectedDietHistory => _selectedDietHistory.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.dietHistory().then((value) {
      _dietHistory.value = value.requireData;
      debugPrint('repository ${_dietHistory.value}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void onDietHistoryClick(DietHistory dietHistory) {
    _selectedDietHistory.value = dietHistory;
  }

  void condition() {
    if (_selectedDietHistory.valueOrNull != null) {
      _loadingContent.value = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.dietHistoryId = _selectedDietHistory.value!.id;
      debugPrint('bloc condition ${requestData.toJson()}');
      _repository.setCondition(requestData).then((value) {
        debugPrint('bloc condition ${value.data}');
        if(value.data != null) _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.value = false);
    }
  }

  void dispose() {
    _loadingContent.close();
    _dietHistory.close();
    _selectedDietHistory.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
