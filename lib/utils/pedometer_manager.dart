import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:behandam/const_&_model/food_meal_alarm.dart';
import 'package:behandam/const_&_model/pedometer.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class PedometerManager {
  @pragma('vm:entry-point')
  static List<Pedometer> getSteps() {
    // Fetch and decode data
    final String steps = (AppSharedPreferences.pedometer);

    if (steps.isNotEmpty) {
      final List<Pedometer> step = Pedometer.decode(steps);

      if (step.length > 7) {
        return step.sublist(step.length - 7, step.length);
      }

      return step;
    }

    return [];
  }

  @pragma('vm:entry-point')
  static Pedometer? getTodayStep() {
    // Fetch and decode data
    final String steps = AppSharedPreferences.pedometer;

    DateTime today = DateTime.now();

    if (steps.isNotEmpty) {
      final List<Pedometer> stepJson = Pedometer.decode(steps);

      Pedometer? step;

      try {
        step = stepJson.firstWhere(
            (element) => element.date == today.toString().substring(0, 10));
      } catch (e) {
        print(e.toString());
      }

      return step;
    }

    return null;
  }

  @pragma('vm:entry-point')
  static Pedometer? checkIsExistPedometer(Pedometer pedometer) {
    // Fetch and decode data
    final String steps = AppSharedPreferences.pedometer;

    if (steps.isNotEmpty) {
      final List<Pedometer> stepJson = Pedometer.decode(steps);

      Pedometer? step;

      try {
        step = stepJson.firstWhere((element) => element == pedometer);
      } catch (e) {
        print(e.toString());
      }

      return step;
    }

    return null;
  }

  @pragma('vm:entry-point')
  static setPedometer(Pedometer pedometer) {
    late String encodedData;
    // Fetch and decode data
    final String data = (AppSharedPreferences.pedometer);
    if (data.isNotEmpty) {
      final List<Pedometer> prefPedometer = Pedometer.decode(data);

      Pedometer? step = checkIsExistPedometer(pedometer);

      if (step != null) {
        // set data
        prefPedometer.remove(step);
        prefPedometer.add(pedometer);

        encodedData = Pedometer.encode([...prefPedometer]);

        AppSharedPreferences.setPedometer(encodedData);

        return;
      }

      // set data
      encodedData = Pedometer.encode([...prefPedometer, pedometer]);

      // write all contact when not new contact
      AppSharedPreferences.setPedometer(encodedData);
    } else {
      // set data
      encodedData = Pedometer.encode([pedometer]);

      // write all contact when not new contact
      AppSharedPreferences.setPedometer(encodedData);
    }
  }
}
