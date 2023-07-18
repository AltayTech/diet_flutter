import 'dart:async';
import 'dart:ui';

import 'package:behandam/base/repository.dart';
import 'package:behandam/const_&_model/pedometer.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/utils/pedometer_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
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
    _kilometerCount.value = 0;
    _calorieBurnCount.value = 0;
    _minCount.value = 159;
    _pedometerOn.value = AppSharedPreferences.pedometerOn;

    Pedometer? pedometer = PedometerManager.getTodayStep();
    double count = 0;
    if (pedometer != null) {
      count = pedometer.count ?? 0;
      _stepCount.value = count.toDouble();
    }
  }

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _advices = BehaviorSubject<AdviceData>();
  final _stepCount = BehaviorSubject<double>();
  final _kilometerCount = BehaviorSubject<double>();
  final _calorieBurnCount = BehaviorSubject<double>();
  final _minCount = BehaviorSubject<int>();
  final _pedometerOn = BehaviorSubject<bool>();
  final _pedestrianStatus = BehaviorSubject<StepCountStatus>();
  List<double> _accelData = List.filled(3, 0.0);
  List<double> _gyroData = List.filled(3, 0.0);
  StreamSubscription? _accelSubscription;
  StreamSubscription? _gyroSubscription;
  static const notificationChannelId = 'pedometer_foreground';
  static const notificationId = 888;
  static const stepIncrease = 0.5;

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<AdviceData> get advices => _advices.stream;

  Stream<double> get stepCountBlocStream => _stepCount.stream;

  Stream<double> get kilometerCount => _kilometerCount.stream;

  Stream<double> get calorieBurnCount => _calorieBurnCount.stream;

  Stream<int> get minCount => _minCount.stream;

  Stream<bool> get pedometerOn => _pedometerOn.stream;

  Stream<StepCountStatus> get pedestrianStatusBlocStream =>
      _pedestrianStatus.stream;

  StepCountStatus get getLastStepStatus => _pedestrianStatus.value;

  void setPedometerOn(bool turnOn) {
    AppSharedPreferences.setPedometerOn(turnOn);
    _pedometerOn.value = turnOn;
  }

  Future<void> startPedometer() async {
    if (_pedometerOn.value) {
      DateTime today = DateTime.now();

      Pedometer? pedometer = PedometerManager.getTodayStep();
      double count = 0;
      if (pedometer != null &&
          pedometer.date == today.toString().substring(0, 10)) {
        count = pedometer.count ?? 0;
        _stepCount.value = count.toDouble();
      }

      final stream = await SensorManager().sensorUpdates(
        sensorId: Sensors.ACCELEROMETER,
        interval: Sensors.SENSOR_DELAY_NORMAL,
      );

      _accelSubscription = stream.listen((sensorEvent) {
        _accelData = sensorEvent.data;

        debugPrint('sensor data 0 => ${sensorEvent.data[0]}');
        debugPrint('sensor data 1 => ${sensorEvent.data[1]}');
        debugPrint('sensor data 2 => ${sensorEvent.data[2]}');

        if (sensorEvent.data[0] > 1 &&
            sensorEvent.data[1] > 1 &&
            sensorEvent.data[2] != sensorEvent.data[0] &&
            sensorEvent.data[2] != sensorEvent.data[1] &&
            sensorEvent.data[2] > sensorEvent.data[0] &&
            sensorEvent.data[2] > sensorEvent.data[1] &&
            sensorEvent.data[2] != 9) {
          increaseData();
        } else if (sensorEvent.data[0] < 9 && sensorEvent.data[2] < 9) {
          increaseData();
        } else if (sensorEvent.data[0] < 0 && sensorEvent.data[2] < 9) {
          increaseData();
        }
      });

      await initializeService();
    }
  }

  void increaseData() {
    _stepCount.value = _stepCount.value + stepIncrease;
    _kilometerCount.value = _stepCount.value / 1350;
    _calorieBurnCount.value = _kilometerCount.value * 48.33;
  }

  void stopPedometer() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();

    if (isRunning) {
      service.invoke("stopService");
    }

    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    var isRunning = await service.isRunning();

    if (!isRunning) {
      const AndroidNotificationChannel channel = AndroidNotificationChannel(
        notificationChannelId, // id
        'DrFit Pedometer', // title
        description:
        'This channel is used for important notifications.', // description
        importance: Importance.low, // importance must be at low or higher level
        playSound: false,
        enableVibration: false,
      );

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      await service.configure(
        androidConfiguration: AndroidConfiguration(
          // this will be executed when app is in foreground or background in separated isolate
          onStart: onStart,
          // auto start service
          autoStart: true,
          isForegroundMode: true,
          notificationChannelId: notificationChannelId,
          // this must match with notification channel you created above.
          initialNotificationTitle: 'DrDiet',
          initialNotificationContent:
          'This channel is used for important notifications',
          foregroundServiceNotificationId: notificationId,
        ),
        iosConfiguration: IosConfiguration(
          // auto start service
          autoStart: true,

          // this will be executed when app is in foreground in separated isolate
          onForeground: onStart,

          // you have to enable background fetch capability on xcode project
          onBackground: (service) {
            return true;
          },
        ),
      );

      service.startService();
    }
  }

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    await AppSharedPreferences.initialize();

    DateTime today = DateTime.now();

    Pedometer? pedometer = PedometerManager.getTodayStep();
    double count = 0;
    if (pedometer != null &&
        pedometer.date == today.toString().substring(0, 10)) {
      count = pedometer.count ?? 0;
    }

    // bring to foreground
    final stream = await SensorManager().sensorUpdates(
      sensorId: Sensors.ACCELEROMETER,
      interval: Sensors.SENSOR_DELAY_NORMAL,
    );

    stream.listen((sensorEvent) {
      if (sensorEvent.data[0] > 1 &&
          sensorEvent.data[1] > 1 &&
          sensorEvent.data[2] != sensorEvent.data[0] &&
          sensorEvent.data[2] != sensorEvent.data[1] &&
          sensorEvent.data[2] > sensorEvent.data[0] &&
          sensorEvent.data[2] > sensorEvent.data[1] &&
          sensorEvent.data[2] != 9) {
        count = count + stepIncrease;
        increaseDataOnService(service, count);
      } else if (sensorEvent.data[0] < 9 && sensorEvent.data[2] < 9) {
        count = count + stepIncrease;
        increaseDataOnService(service, count);
      } else if (sensorEvent.data[0] < 0 && sensorEvent.data[2] < 9) {
        count = count + stepIncrease;
        increaseDataOnService(service, count);
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> increaseDataOnService(
      ServiceInstance service, double count) async {
    // save data
    DateTime dateTime = DateTime.now();
    Pedometer pedometer =
        Pedometer(count: count, date: dateTime.toString().substring(0, 10));
    PedometerManager.setPedometer(pedometer);

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        flutterLocalNotificationsPlugin.show(
          notificationId,
          '${count.toInt()} steps',
          'Your target is 10,000 steps',
          const NotificationDetails(
            android: AndroidNotificationDetails(
                notificationChannelId, 'DrDiet PEDOMETER FOREGROUND SERVICE',
                ongoing: true,
                autoCancel: false,
                importance: Importance.low,
                priority: Priority.low,
                playSound: false,
                vibrationPattern: null,
                enableVibration: false,
                onlyAlertOnce: true,
                icon: '@mipmap/ic_launcher'),
          ),
        );
      }
    }
  }

  void dispose() {
    _loadingContent.close();
    _advices.close();
    _pedestrianStatus.close();
    _stepCount.close();
    _kilometerCount.close();
    _calorieBurnCount.close();
    _minCount.close();
    _pedometerOn.close();
  }
}
