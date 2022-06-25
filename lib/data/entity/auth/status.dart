import 'package:json_annotation/json_annotation.dart';
part 'status.g.dart';

@JsonSerializable()
class CheckStatus {
  @JsonKey(name: "next")
  String? next;
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "existed")
  bool? isExist;


  CheckStatus();

  factory CheckStatus.fromJson(Map<String, dynamic> json) => _$CheckStatusFromJson(json);
  Map<String, dynamic> toJson() => _$CheckStatusToJson(this);
}