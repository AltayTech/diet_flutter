import 'package:alarm/alarm.dart';
import 'package:behandam/const_&_model/food_meal_alarm.dart';
import 'package:behandam/data/sharedpreferences.dart';

class FoodMealsNotif {
  static Future<List<FoodMealAlarm>> getAlarms() async {
    // Fetch and decode data
    final String foodMealsAlarms = (await AppSharedPreferences.foodMealsAlarms);

    if (foodMealsAlarms.isNotEmpty) {
      final List<FoodMealAlarm> foodMealsAlarm = FoodMealAlarm.decode(foodMealsAlarms);

      return foodMealsAlarm;
    }

    return [];
  }

  static Future<bool> checkSetAlarm(FoodMealAlarm foodMealAlarm) async {
    // Fetch and decode data
    final String foodMealsAlarms = (await AppSharedPreferences.foodMealsAlarms);

    if (foodMealsAlarms.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(foodMealsAlarms);

      return prefFoodMealsAlarm.contains(foodMealAlarm) && foodMealAlarm.isEnabled;
    }

    return false;
  }

  static Future<void> setFoodMealAlarm(FoodMealAlarm foodMealAlarm) async {
    late String encodedData;
    // Fetch and decode data
    final String data = (await AppSharedPreferences.foodMealsAlarms);
    if (data.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(data);

      // search new contact
      List<FoodMealAlarm> diffFoodMeal = [];
      diffFoodMeal = prefFoodMealsAlarm
          .where((element) => !prefFoodMealsAlarm.contains(foodMealAlarm))
          .toList();

      if (diffFoodMeal.isNotEmpty) {
        // set data
        encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm, foodMealAlarm]);

        await AppSharedPreferences.setFoodMealsAlarms(encodedData);
      }

      return;
    }
    // set data
    encodedData = FoodMealAlarm.encode([foodMealAlarm]);

    // write all contact when not new contact
    await AppSharedPreferences.setFoodMealsAlarms(encodedData);
  }

  static Future<void> disableAlarm(FoodMealAlarm foodMealAlarm) async {
    late String encodedData;
    // Fetch and decode data
    final String data = (await AppSharedPreferences.foodMealsAlarms);
    if (data.isNotEmpty) {
      final List<FoodMealAlarm> prefFoodMealsAlarm = FoodMealAlarm.decode(data);

      List<FoodMealAlarm> diff = prefFoodMealsAlarm
          .where((element) => prefFoodMealsAlarm.contains(foodMealAlarm))
          .toList();

      if (diff.isNotEmpty) {
        prefFoodMealsAlarm.remove(foodMealAlarm);
        Alarm.stop(foodMealAlarm.id!);
        foodMealAlarm.isEnabled = false;
        // add new as disabled
        prefFoodMealsAlarm.add(foodMealAlarm);
      }

      // set data
      encodedData = FoodMealAlarm.encode([...prefFoodMealsAlarm]);

      await AppSharedPreferences.setFoodMealsAlarms(encodedData);
    }
  }
}
