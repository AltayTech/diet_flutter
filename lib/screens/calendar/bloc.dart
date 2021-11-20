import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class CalendarBloc {
  CalendarBloc() {
    if(_startDate.valueOrNull == null) _startDate.value = DateTime.now().subtract(Duration(days: 100)).toString().substring(0, 10);
    if(_endDate.valueOrNull == null) _endDate.value = DateTime.now().add(Duration(days: 100)).toString().substring(0, 10);
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _endDate = BehaviorSubject<String>();
  final _startDate = BehaviorSubject<String>();
  final _calendar = BehaviorSubject<CalendarData?>();
  // final FoodListBloc _foodListBloc = FoodListBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<String> get startDate => _startDate.stream;

  Stream<String> get endDate => _endDate.stream;
  //
  Stream<CalendarData?> get calendar => _calendar.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.calendar(_startDate.value, _endDate.value).then((value) {
      _calendar.value = value.requireData;
      // debugPrint('calendar2 ${_calendar.value?.terms[0].menus?.length}');
    }).catchError((onError) => debugPrint('repository error $onError')).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _startDate.close();
    _endDate.close();
    _calendar.close();
  }
}
