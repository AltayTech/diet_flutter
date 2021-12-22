import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/overview.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

class OverviewBloc {
  OverviewBloc() {
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _overview = BehaviorSubject<OverviewData>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<OverviewData> get dietHistory => _overview.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  String? get path => _path;

  String? _path;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.overview().then((value) {
      _overview.value = value.requireData;
      _path = value.next;
      debugPrint('repository ${_overview.value}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void condition() {
    // _loadingContent.value = true;
    // ConditionRequestData requestData = ConditionRequestData();
    // // requestData.dietHistoryId = _selectedDietHistory.value!.id;
    // debugPrint('bloc condition ${requestData.toJson()}');
    // _repository.overview().then((value) {
    //   debugPrint('bloc condition ${value.data}');
    //   if (value.data != null) _navigateTo.fire(value.next);
    // }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _overview.close();
    _navigateTo.close();
    _showServerError.close();
  }
}
