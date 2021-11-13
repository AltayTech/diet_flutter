import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/screens/ticket/ticket_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ticket_item.g.dart';

enum TicketStatus {
  @JsonValue(0)
  PendingAdminResponse,
  @JsonValue(1)
  PendingUserResponse,
  @JsonValue(2)
  OnHold,
  @JsonValue(3)
  GlobalIssue,
  @JsonValue(4)
  Resolved,
  @JsonValue(5)
  Closed
}
enum TypeTicketItem {
  @JsonValue(0)
  VOICE,
  @JsonValue(1)
  IMAGE,
  @JsonValue(2)
  VIDEO,
  @JsonValue(3)
  FILE
}

enum TypeTicketMessage {
  @JsonValue(0)
  TEXT,
  @JsonValue(1)
  TEXT_AND_ATTACHMENT,
  @JsonValue(2)
  VOICE,
  @JsonValue(3)
  TEMP
}
enum MediumType {
  @JsonValue(0)
  IMAGE,
  @JsonValue(1)
  VIDEO,
  @JsonValue(2)
  NONE,
  @JsonValue(3)
  AUDIO,
  @JsonValue(4)
  file
}

@JsonSerializable()
class TicketModel {
  @JsonKey(name: "count")
  int? count;

  @JsonKey(name: "items")
  late List<TicketItem> items;

  @JsonKey(name: "messages")
  List<MessageTicket>? messages;

  @JsonKey(name: "files")
  List<Media>? files;

  @JsonKey(name: "created_at")
  String? createdAt;

  TicketModel();

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}

@JsonSerializable()
class TicketItem {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "created_at")
  String? createdAt;

  @JsonKey(name: "status")
  TicketStatus? status;

  TicketItem();

  factory TicketItem.fromJson(Map<String, dynamic> json) => _$TicketItemFromJson(json);

  Map<String, dynamic> toJson() => _$TicketItemToJson(this);
}

@JsonSerializable()
class SupportModel {
  @JsonKey(name: "count")
  int? count;

  @JsonKey(name: "items")
  late List<SupportItem> items;

  SupportModel();

  factory SupportModel.fromJson(Map<String, dynamic> json) => _$SupportModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupportModelToJson(this);
}

@JsonSerializable()
class SupportItem {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "display_name")
  String? displayName;

  @JsonKey(name: "ticket_name")
  String? ticketName;

  bool? selected;

  bool get isSelected => selected ?? false;

  SupportItem();

  factory SupportItem.fromJson(Map<String, dynamic> json) => _$SupportItemFromJson(json);

  Map<String, dynamic> toJson() => _$SupportItemToJson(this);
}

@JsonSerializable()
class SendTicket {
  @JsonKey(name: "department_id")
  int? departmentId;

  @JsonKey(name: "body")
  String? body;

  @JsonKey(name: "title")
  String? title;

  @JsonKey(name: "has_attachment", defaultValue: false)
  late bool hasAttachment;

  @JsonKey(name: "is_voice", defaultValue: false)
  late bool isVoice;

  SendTicket();

  factory SendTicket.fromJson(Map<String, dynamic> json) => _$SendTicketFromJson(json);

  Map<String, dynamic> toJson() => _$SendTicketToJson(this);
}

@JsonSerializable()
class MessageTicket {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "ticket_id")
  int? ticketId;
  @JsonKey(name: "body")
  String? body;
  @JsonKey(name: "type")
  TypeTicketMessage? type;

  @JsonKey(name: "is_admin")
  int? isAdmin;

  @JsonKey(name: "file")
  Media? file;

  @JsonKey(name: "template")
  TempTicket? temp;

  @JsonKey(name: "created_at")
  String? createdAt;

  MessageTicket();

  factory MessageTicket.fromJson(Map<String, dynamic> json) => _$MessageTicketFromJson(json);

  Map<String, dynamic> toJson() => _$MessageTicketToJson(this);
}

@JsonSerializable()
class TempItem {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "alter_text")
  String? alterText;
  @JsonKey(name: "media")
  List<TempMedia>? media;

  TempItem();

  factory TempItem.fromJson(Map<String, dynamic> json) => _$TempItemFromJson(json);

  Map<String, dynamic> toJson() => _$TempItemToJson(this);
}

@JsonSerializable()
class TempTicket {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "data")
  List<TempItem>? data;

  TempTicket();

  factory TempTicket.fromJson(Map<String, dynamic> json) => _$TempTicketFromJson(json);

  Map<String, dynamic> toJson() => _$TempTicketToJson(this);
}

@JsonSerializable()
class TempMedia {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "file_name")
  String? fileName;
  @JsonKey(name: "medium_type")
  MediumType? mediumType;
  @JsonKey(name: "medium_urls")
  Media? mediumUrls;

  bool? progress;

  TempMedia();

  factory TempMedia.fromJson(Map<String, dynamic> json) => _$TempMediaFromJson(json);

  Map<String, dynamic> toJson() => _$TempMediaToJson(this);
}
