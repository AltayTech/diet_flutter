import 'package:json_annotation/json_annotation.dart';

part 'inbox.g.dart';

enum INBOX_ACTION_TYPE {
  OPEN_WEB_URL,
  OPEN_ESPECIAL_APP,
  OPEN_PAGE,
  OPEN_TELEGRAM_CHANNEL,
  OPEN_INSTAGRAM_PAGE,
  CALL_SERVICE
}

@JsonSerializable()
class Inbox {
  @JsonKey(name: "inbox_count")
  int? count;

  @JsonKey(name: "items")
  late List<InboxItem> items;

  Inbox();

  factory Inbox.fromJson(Map<String, dynamic> json) => _$InboxFromJson(json);

  Map<String, dynamic> toJson() => _$InboxToJson(this);
}

@JsonSerializable()
class InboxItem {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "text")
  String? text;

  @JsonKey(name: "created_at")
  String? createdAt;

  @JsonKey(name: "seen_at")
  String? seenAt;

  @JsonKey(name: "inbox")
  late InboxItem inbox;

  @JsonKey(name: "action_type")
  INBOX_ACTION_TYPE? actionType;

  @JsonKey(name: "action")
  late String action;

  InboxItem();

  factory InboxItem.fromJson(Map<String, dynamic> json) => _$InboxItemFromJson(json);

  Map<String, dynamic> toJson() => _$InboxItemToJson(this);
}
