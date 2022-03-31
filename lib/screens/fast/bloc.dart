import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/extensions/object.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class FastBloc {
  FastBloc() {
    _loadContent();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _patterns = BehaviorSubject<List<FastPatternData>>();
  final _selectedPattern = BehaviorSubject<FastPatternData>();
  final _fast = BehaviorSubject<FastMenuRequestData>();

  // final FoodListBloc _foodListBloc = FoodListBloc();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<List<FastPatternData>> get patterns => _patterns.stream;

  Stream<FastPatternData> get selectedPattern => _selectedPattern.stream;

  Stream<FastMenuRequestData> get fast => _fast.stream;

  void _loadContent() {
    _loadingContent.safeValue = true;
    _repository.fastPattern().then((value) {
      value.data?.let((it) {
        _patterns.value = it.map((e) => e).toList();
      });
      debugPrint('repository ${_patterns.value.length}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void changeToFast(FastPatternData pattern) {
    _loadingContent.safeValue = true;
    _selectedPattern.value = pattern;
    final fastMenuRequestData = FastMenuRequestData();
    fastMenuRequestData.patternId = _patterns.value.indexWhere((element) => element == pattern);
    fastMenuRequestData.isFasting = true;
    _repository.changeToFast(fastMenuRequestData).then((value) {
      _fast.value = value.requireData;
    }).whenComplete(() {
       _loadingContent.safeValue = false;
    });
  }

  void changeToOriginal(String date) {
    _loadingContent.safeValue = true;
    final fastMenuRequestData = FastMenuRequestData();
    fastMenuRequestData.isFasting = false;
    fastMenuRequestData.date = date;
    _repository.changeToFast(fastMenuRequestData).then((value) {
      _fast.value = value.requireData;
      // _foodListBloc.onRefresh(invalidate: true);
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void dispose() {
    _loadingContent.close();
    _patterns.close();
    _fast.close();
    _selectedPattern.close();
  }
}
