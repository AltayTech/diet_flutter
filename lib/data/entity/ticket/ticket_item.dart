import 'package:json_annotation/json_annotation.dart';
part 'ticket_item.g.dart';

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

  TicketItem();

  factory TicketItem.fromJson(Map<String, dynamic> json) => _$TicketItemFromJson(json);

  Map<String, dynamic> toJson() => _$TicketItemToJson(this);
}
