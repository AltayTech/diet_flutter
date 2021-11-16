import 'package:json_annotation/json_annotation.dart';
part 'help.g.dart';

@JsonSerializable()
class Help {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "helpers")
  List<Help>? helpers;
  @JsonKey(name: "media")
  List<Help>? media;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "updated_at")
  String? updatedAt;
  @JsonKey(name: "model_id")
  int? modelId;
  @JsonKey(name: "model_type")
  String? modelType;
  @JsonKey(name: "order")
  int? order;
  @JsonKey(name: "body")
  String? body;
  @JsonKey(name: "url")
  String? url;

  Help();

  factory Help.fromJson(Map<String, dynamic> json) => _$HelpFromJson(json);
  Map<String, dynamic> toJson() => _$HelpToJson(this);
}