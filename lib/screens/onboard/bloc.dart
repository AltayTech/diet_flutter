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
  final _sliders = BehaviorSubject<List<Slider>>();
  final _navigateTo = LiveEvent();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream<List<Slider>> get sliders => _sliders.stream;

  Stream get navigateTo => _navigateTo.stream;

  void getSlider() {
    _waiting.safeValue = true;
    _repository.getSliders().then((value) {
      _sliders.safeValue = value.data!.items!;
      }).whenComplete(() {
        _waiting.safeValue = false;
      });
  }

  void dispose() {
    _waiting.close();
    _sliders.close();
    _navigateTo.close();
  }
}
