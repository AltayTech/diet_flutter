import 'dart:convert';

class FoodMealAlarm {
  int? id;
  final String? title;
  String? dateTime;
  bool isEnabled;

  FoodMealAlarm({this.id, this.title, this.dateTime, this.isEnabled = true});

  factory FoodMealAlarm.fromJson(Map<String, dynamic> jsonData) {
    return FoodMealAlarm(
        id: jsonData['id'],
        title: jsonData['title'],
        dateTime: jsonData['dateTime'],
        isEnabled: jsonData['isEnabled']);
  }

  static Map<String, dynamic> toMap(FoodMealAlarm foodMealAlarm) => {
        'id': foodMealAlarm.id,
        'title': foodMealAlarm.title,
        'dateTime': foodMealAlarm.dateTime,
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
          title == other.title &&
          dateTime == other.dateTime &&
          isEnabled == other.isEnabled;
}
