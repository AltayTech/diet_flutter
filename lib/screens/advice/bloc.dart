import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class AdviceBloc {
  AdviceBloc() {
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _advices = BehaviorSubject<AdviceData>();
  // final _selectedPattern = BehaviorSubject<FastPatternData>();
  // final _fast = BehaviorSubject<FastMenuRequestData>();
  // final FoodListBloc _foodListBloc = FoodListBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<AdviceData> get advices => _advices.stream;
  //
  // Stream<FastPatternData> get selectedPattern => _selectedPattern.stream;
  //
  // Stream<FastMenuRequestData> get fast => _fast.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.advice().then((value) {
      _advices.value = value.data!;
      debugPrint('advice bloc ${_advices.value}');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _advices.close();
  }
}
