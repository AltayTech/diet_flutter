import 'package:json_annotation/json_annotation.dart';

part 'block_user.g.dart';

@JsonSerializable()
class BlockUser {
  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "items")
  List<BlockUser>? items;
  BlockUser();

  factory BlockUser.fromJson(Map<String, dynamic> json) => _$BlockUserFromJson(json);

  Map<String, dynamic> toJson() => _$BlockUserToJson(this);
}