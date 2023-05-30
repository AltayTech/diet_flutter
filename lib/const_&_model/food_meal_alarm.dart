import 'dart:convert';

class FoodMealAlarm {
  int? id;
  int? type;
  String? title;
  String? time;
  bool? isEnabled;

  FoodMealAlarm({this.id, this.type, this.title, this.time, this.isEnabled = false});

  factory FoodMealAlarm.fromJson(Map<String, dynamic> jsonData) {
    return FoodMealAlarm(
        id: jsonData['id'],
        type: jsonData['type'],
        title: jsonData['title'],
        time: jsonData['time'],
        isEnabled: jsonData['isEnabled']);
  }

  static Map<String, dynamic> toMap(FoodMealAlarm foodMealAlarm) => {
        'id': foodMealAlarm.id,
        'type': foodMealAlarm.type,
        'title': foodMealAlarm.title,
        'time': foodMealAlarm.time,
        'isEnabled': foodMealAlarm.isEnabled
      };

  static String encode(List<FoodMealAlarm> foodMealAlarm) => json.encode(
        foodMealAlarm.map<Map<String, dynamic>>((element) => FoodMealAlarm.toMap(element)).toList(),
      );

  static List<FoodMealAlarm> decode(String foodMealAlarm) =>
      (json.decode(foodMealAlarm) as List<dynamic>)
          .map<FoodMealAlarm>((item) => FoodMealAlarm.fromJson(item))
          .toList();

  @override
  bool operator ==(Object other) =>
      // 2 books are equal if and only if they are both Book and have exactly
      // the same id AND name.
      identical(this, other) ||
      other is FoodMealAlarm &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          type == other.type &&
          time == other.time;
}
