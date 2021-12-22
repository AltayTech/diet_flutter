import 'package:json_annotation/json_annotation.dart';
part 'plan.g.dart';

@JsonSerializable()
class Plan {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "expert_plannings")
  List<Planning>? expertPlanning;
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "jdate")
  String? jDate;
  @JsonKey(name: "is_holiday")
  int? isHoliday;

  Plan();

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
  Map<String, dynamic> toJson() => _$PlanToJson(this);
}

@JsonSerializable()
class Planning {
  @JsonKey(name: "admin_id")
  int? adminId;
  @JsonKey(name: "date_times")
  List<Planning>? dateTimes;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "start_time")
  String? startTime;
  @JsonKey(name: "end_time")
  String? endTime;

  Planning();

  factory Planning.fromJson(Map<String, dynamic> json) => _$PlanningFromJson(json);
  Map<String, dynamic> toJson() => _$PlanningToJson(this);
}