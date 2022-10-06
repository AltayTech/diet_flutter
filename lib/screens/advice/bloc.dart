import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class AdviceBloc {
  AdviceBloc() ;

  Repository _repository = Repository.getInstance();
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

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.advice().then((value) {
      _advices.value = value.data!;
      debugPrint('advice bloc ${_advices.value}');
    }).whenComplete(() => _loadingContent.safeValue = false);
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
    _advices.close();
  }
}
