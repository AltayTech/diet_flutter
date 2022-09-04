import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/slider/slider.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

class OnboardBloc {
  OnboardBloc() {
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  late String _path;

  final _waiting = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  void dispose() {
    _waiting.close();
    _navigateTo.close();
  }
}
