import 'package:json_annotation/json_annotation.dart';
part 'reserved_meeting.g.dart';

@JsonSerializable()
class HistoryOutput {
  @JsonKey(name: "dates")
  List<HistoryOutput>? dates;
  @JsonKey(name: "date")
  String? date;
  @JsonKey(name: "expert_plannings")
  History? expertPlanning;

  HistoryOutput();

  factory HistoryOutput.fromJson(Map<String, dynamic> json) => _$HistoryOutputFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryOutputToJson(this);
}

@JsonSerializable()
class History {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "admin_id")
  int? adminId;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "start_time")
  String? startTime;

  History();

  factory History.fromJson(Map<String, dynamic> json) => _$HistoryFromJson(json);
  Map<String, dynamic> toJson() => _$HistoryToJson(this);
}