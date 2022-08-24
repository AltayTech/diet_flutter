import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';

import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class FlowStarterBloc {
  FlowStarterBloc() {}

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _popDialog = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get popDialog => _popDialog.stream;

  Stream get showServerError => _showServerError.stream;

  void nextStep() {
    _repository.nextStep().then((value) {
      _navigateTo.fire(value.next!);
    }).catchError((onError) {
      _showServerError.fire(onError);
    }).whenComplete(() => _popDialog.fire(true));
  }

  void dispose() {
    _loadingContent.close();
    _navigateTo.close();
    _popDialog.close();
    _showServerError.close();
  }
}
