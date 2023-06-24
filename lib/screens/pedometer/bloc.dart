import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:rxdart/rxdart.dart';

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
    _stepCount.value = 0;
    _kilometerCount.value = 0;
    _calorieBurnCount.value = 0;
    _minCount.value = 159;
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _advices = BehaviorSubject<AdviceData>();
  final _stepCount = BehaviorSubject<double>();
  final _kilometerCount = BehaviorSubject<double>();
  final _calorieBurnCount = BehaviorSubject<double>();
  final _minCount = BehaviorSubject<int>();
  final _pedestrianStatus = BehaviorSubject<StepCountStatus>();
  List<double> _accelData = List.filled(3, 0.0);
  List<double> _gyroData = List.filled(3, 0.0);
  StreamSubscription? _accelSubscription;
  StreamSubscription? _gyroSubscription;

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<AdviceData> get advices => _advices.stream;

  Stream<double> get stepCountBlocStream => _stepCount.stream;

  Stream<double> get kilometerCount => _kilometerCount.stream;

  Stream<double> get calorieBurnCount => _calorieBurnCount.stream;

  Stream<int> get minCount => _minCount.stream;

  Stream<StepCountStatus> get pedestrianStatusBlocStream => _pedestrianStatus.stream;

  StepCountStatus get getLastStepStatus => _pedestrianStatus.value;

  Future<void> startPedometer() async {
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_NORMAL,
    );

    _accelSubscription = stream.listen((sensorEvent) {
      _accelData = sensorEvent.data;

      debugPrint('data 0 => ${sensorEvent.data[0]}');
      debugPrint('data 1 => ${sensorEvent.data[1]}');
      debugPrint('data 2 => ${sensorEvent.data[2]}');

      if (sensorEvent.data[0] > 1 &&
          sensorEvent.data[1] > 1 &&
          sensorEvent.data[2] > 1 &&
          sensorEvent.data[2] != 9 &&
          sensorEvent.data[0] != sensorEvent.data[1] &&
          sensorEvent.data[1] != sensorEvent.data[2]) {
        _stepCount.value = _stepCount.value + 0.15;
        _kilometerCount.value = _stepCount.value / 3265;
        _calorieBurnCount.value = _kilometerCount.value * 48.33;
      }
    });
  }

  void stopPedometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  void dispose() {
    _loadingContent.close();
    _advices.close();
    _pedestrianStatus.close();
    _stepCount.close();
    _kilometerCount.close();
    _calorieBurnCount.close();
    _minCount.close();
  }
}
