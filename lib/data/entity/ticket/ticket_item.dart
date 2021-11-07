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

@JsonSerializable()
class TicketModel {
  @JsonKey(name: "count")
  int? count;

  @JsonKey(name: "items")
  late List<TicketItem> items;

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

  SupportItem();

  factory SupportItem.fromJson(Map<String, dynamic> json) => _$SupportItemFromJson(json);

  Map<String, dynamic> toJson() => _$SupportItemToJson(this);
}