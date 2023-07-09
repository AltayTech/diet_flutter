import 'dart:async';
import 'dart:ui';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
    _pedometerOn.value = AppSharedPreferences.pedometerOn;
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
        } else if (sensorEvent.data[0] < 9 &&
            sensorEvent.data[1] < 0 &&
            sensorEvent.data[2] < 9) {
          increaseData();
        } else if (sensorEvent.data[0] < 0 &&
            sensorEvent.data[1] < 0 &&
            sensorEvent.data[2] < 9) {
          increaseData();
        }
      });

      await initializeService();
    }
  }

  void increaseData() {
    _stepCount.value = _stepCount.value + 1;
    _kilometerCount.value = _stepCount.value / 1350;
    _calorieBurnCount.value = _kilometerCount.value * 48.33;
  }

  void stopPedometer() {
    if (_accelSubscription == null) return;
    _accelSubscription?.cancel();
    _accelSubscription = null;
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      notificationChannelId, // id
      'DrFit Pedometer', // title
      description:
          'This channel is used for important notifications.', // description
      importance: Importance.max, // importance must be at low or higher level
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
        initialNotificationTitle: 'AWESOME SERVICE',
        initialNotificationContent: 'Initializing',
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

  @pragma('vm:entry-point')
  static Future<void> onStart(ServiceInstance service) async {
    // Only available for flutter 3.0.0 and later
    DartPluginRegistrant.ensureInitialized();

    // For flutter prior to version 3.0.0
    // We have to register the plugin manually

    await AppSharedPreferences.initialize();
    //await preferences.setString("hello", "world");

    /// OPTIONAL when use custom notification
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

    // bring to foreground
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (service is AndroidServiceInstance) {
        if (await service.isForegroundService()) {
          flutterLocalNotificationsPlugin.show(
            notificationId,
            'COOL SERVICE',
            'Awesome ${DateTime.now()}',
            const NotificationDetails(
              android: AndroidNotificationDetails(
                notificationChannelId,
                'MY FOREGROUND SERVICE',
                icon: 'ic_bg_service_small',
                ongoing: true,
              ),
            ),
          );
        }
      }
    });
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
