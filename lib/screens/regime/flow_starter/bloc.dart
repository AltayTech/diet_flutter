import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:rxdart/rxdart.dart';

class FlowStarterBloc {
  FlowStarterBloc() {}

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _popDialog = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get popDialog => _popDialog.stream;

  Stream get showServerError => _showServerError.stream;

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void nextStep() {
    _repository.nextStep().then((value) {
      _navigateTo.fire(value.next!);
    }).whenComplete(() => _popDialog.fire(true));
  }

  void onRetryAfterNoInternet() {
    setRepository();
    nextStep();
  }

  void dispose() {
    _loadingContent.close();
    _navigateTo.close();
    _popDialog.close();
    _showServerError.close();
  }
}
