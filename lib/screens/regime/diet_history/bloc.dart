import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';

import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class DietHistoryBloc {
  DietHistoryBloc() {
    loadContent();
  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _dietHistory = BehaviorSubject<DietHistoryData>();
  final _selectedDietHistory = BehaviorSubject<DietHistory?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<DietHistoryData> get dietHistory => _dietHistory.stream;

  Stream<DietHistory?> get selectedDietHistory => _selectedDietHistory.stream;
  DietHistory? get selectedDietHistoryValue => _selectedDietHistory.stream.valueOrNull;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.dietHistory().then((value) {
      _dietHistory.value = value.requireData;
      debugPrint('repository ${_dietHistory.value}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void onDietHistoryClick(DietHistory dietHistory) {
    _selectedDietHistory.value = dietHistory;
  }

  void condition() {
    if (_selectedDietHistory.valueOrNull != null) {
      _loadingContent.safeValue = true;
      ConditionRequestData requestData = ConditionRequestData();
      requestData.dietHistoryId = _selectedDietHistory.value!.id;
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

  void onRetryAfterNoInternet() {
    setRepository();
  }

  void onRetryLoadingPage() {
    setRepository();
    loadContent();
  }

  void dispose() {
    _loadingContent.close();
    _dietHistory.close();
    _selectedDietHistory.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
