import 'dart:convert';

class Pedometer {
  double? count;
  String? date;

  Pedometer({this.count, this.date});

  factory Pedometer.fromJson(Map<String, dynamic> jsonData) {
    return Pedometer(count: jsonData['count'], date: jsonData['time']);
  }

  static Map<String, dynamic> toMap(Pedometer pedometer) => {
        'count': pedometer.count,
        'time': pedometer.date,
      };

  static String encode(List<Pedometer> foodMealAlarm) => json.encode(
        foodMealAlarm
            .map<Map<String, dynamic>>((element) => Pedometer.toMap(element))
            .toList(),
      );

  static List<Pedometer> decode(String pedometer) =>
      (json.decode(pedometer) as List<dynamic>)
          .map<Pedometer>((item) => Pedometer.fromJson(item))
          .toList();

  @override
  bool operator ==(Object other) =>
      // 2 books are equal if and only if they are both Book and have exactly
      // the same id AND name.
      identical(this, other) ||
      other is Pedometer &&
          runtimeType == other.runtimeType &&
          date == other.date;
}
