import 'package:json_annotation/json_annotation.dart';
part 'inbox.g.dart';

@JsonSerializable()
class Inbox {
  @JsonKey(name: "inbox_count")
  int? count;

  Inbox();

  factory Inbox.fromJson(Map<String, dynamic> json) => _$InboxFromJson(json);

  Map<String, dynamic> toJson() => _$InboxToJson(this);
}
