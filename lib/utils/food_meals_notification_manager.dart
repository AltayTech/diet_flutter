import 'package:alarm/alarm.dart';
import 'package:behandam/const_&_model/food_meal_alarm.dart';
import 'package:behandam/data/sharedpreferences.dart';

class FoodMealsNotificationManager {
  static Future<List<FoodMealAlarm>> getAlarms() async {
    // Fetch and decode data
    final String foodMealsAlarms = (AppSharedPreferences.foodMealsAlarms);

    if (foodMealsAlarms.isNotEmpty) {
      final List<FoodMealAlarm> foodMealsAlarm = FoodMealAlarm.decode(foodMealsAlarms);

      return foodMealsAlarm;
    }

    return [];
  }

  static FoodMealAlarm? checkIsExistAlarm(FoodMealAlarm foodMealAlarm) {
    // Fetch and decode data
    final String foodMealsAlarms = AppSharedPreferences.foodMealsAlarms;

    if (foodMealsAlarms.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(foodMealsAlarms);

      FoodMealAlarm? meal;

      try {
        meal =
            prefFoodMealsAlarm.firstWhere((element) => element == foodMealAlarm);
      } catch (e) {
        print(e.toString());
      }

       return meal;
    }

    return null;
  }

  static bool checkSetAlarm(FoodMealAlarm foodMealAlarm) {
    if (foodMealAlarm.isEnabled!) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> setFoodMealAlarm(FoodMealAlarm foodMealAlarm) async {
    late String encodedData;
    // Fetch and decode data
    final String data = (AppSharedPreferences.foodMealsAlarms);
    if (data.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(data);

      FoodMealAlarm? meal = checkIsExistAlarm(foodMealAlarm);

      if (meal != null) {
        // set data
        encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm]);

        await AppSharedPreferences.setFoodMealsAlarms(encodedData);

        return;
      }

      // set data
      encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm, foodMealAlarm]);

      // write all contact when not new contact
      await AppSharedPreferences.setFoodMealsAlarms(encodedData);
    } else {
      // set data
      encodedData = FoodMealAlarm.encode([foodMealAlarm]);

      // write all contact when not new contact
      await AppSharedPreferences.setFoodMealsAlarms(encodedData);
    }
  }

  static Future<void> disableAlarm(FoodMealAlarm foodMealAlarm) async {
    late String encodedData;
    // Fetch and decode data
    final String data = (AppSharedPreferences.foodMealsAlarms);
    if (data.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(data);

      Alarm.stop(foodMealAlarm.id!);

      try {
        int index =
            prefFoodMealsAlarm.indexWhere((element) => element == foodMealAlarm);

        foodMealAlarm.isEnabled = false;
        prefFoodMealsAlarm[index] = foodMealAlarm;
      } catch (e) {
        print(e.toString());
      }

      // set data
      encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm]);

      await AppSharedPreferences.setFoodMealsAlarms(encodedData);
    }
  }

  static Future<void> enableAlarm(FoodMealAlarm foodMealAlarm) async {
    late String encodedData;
    // Fetch and decode data
    final String data = (AppSharedPreferences.foodMealsAlarms);
    if (data.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(data);

      try {
        int index =
            prefFoodMealsAlarm.indexWhere((element) => element == foodMealAlarm);

        foodMealAlarm.isEnabled = true;
        prefFoodMealsAlarm[index] = foodMealAlarm;
      } catch (e) {
        print(e.toString());
      }

      // set data
      encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm]);

      await AppSharedPreferences.setFoodMealsAlarms(encodedData);
    }
  }

  static Future<void> setAlarmMeals(int id, String title, String body, DateTime dateTime) async {
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: 'assets/notif_sound/notification-sound.mp3',
      loopAudio: false,
      vibrate: false,
      fadeDuration: 3.0,
      notificationTitle: title,
      notificationBody: body,
      enableNotificationOnKill: true,
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }
}
