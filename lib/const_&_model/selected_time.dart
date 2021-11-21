import 'package:behandam/data/entity/psy/plan.dart';

class SelectedTime {
  String? adviserName;
  String? adviserImage;
  int? adviserId;
  List<Planning>? times;
  String? date;
  int? price;
  int? packageId;
  int? duration;

  SelectedTime({
    required this.adviserName,
    required this.adviserImage,
    required this.adviserId,
    required this.times,
    required this.date,
    required this.price,
    required this.packageId,
    required this.duration,
  });
}