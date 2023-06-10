import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

enum StepCountStatus {
  WALKING('walking'),
  STOPPED('stopped'),
  UNKNOWN('unknown');

// can add more properties or getters/methods if needed
  final String value;

// can use named parameters if you want
  const StepCountStatus(this.value);
}

class PedometerBloc {
  PedometerBloc() {
    initPlatformState();
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _advices = BehaviorSubject<AdviceData>();
  final _stepCount = BehaviorSubject<int>();
  final _pedestrianStatus = BehaviorSubject<StepCountStatus>();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<AdviceData> get advices => _advices.stream;

  Stream<int> get stepCountBlocStream => _stepCount.stream;

  Stream<StepCountStatus> get pedestrianStatusBlocStream => _pedestrianStatus.stream;

  Stream<StepCount>? stepCountStream;

  Stream<PedestrianStatus>? pedestrianStatusStream;

  StepCountStatus get getLastStepStatus => _pedestrianStatus.value;

  void onStepCount(StepCount event) {
    /// Handle step count changed
    int steps = event.steps;
    DateTime timeStamp = event.timeStamp;

    _stepCount.value = steps;
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    /// Handle status changed
    String status = event.status;
    DateTime timeStamp = event.timeStamp;

    _pedestrianStatus.value = status == 'walking'
        ? StepCountStatus.WALKING
        : status == 'stopped'
            ? StepCountStatus.STOPPED
            : StepCountStatus.UNKNOWN;
  }

  void onPedestrianStatusError(error) {
    /// Handle the error
  }

  void onStepCountError(error) {
    /// Handle the error
  }

  Future<void> initPlatformState() async {
    /// Init streams
    pedestrianStatusStream = await Pedometer.pedestrianStatusStream;
    stepCountStream = await Pedometer.stepCountStream;

    /// Listen to streams and handle errors
    stepCountStream!.listen(onStepCount).onError(onStepCountError);
    pedestrianStatusStream!.listen(onPedestrianStatusChanged).onError(onPedestrianStatusError);
  }

  void dispose() {
    _loadingContent.close();
    _advices.close();
    _pedestrianStatus.close();
    _stepCount.close();
  }
}
