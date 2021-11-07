// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel()
  ..count = json['count'] as int?
  ..items = (json['items'] as List<dynamic>)
      .map((e) => TicketItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
    };

TicketItem _$TicketItemFromJson(Map<String, dynamic> json) => TicketItem()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..createdAt = json['created_at'] as String?
  ..status = $enumDecodeNullable(_$TicketStatusEnumMap, json['status']);

Map<String, dynamic> _$TicketItemToJson(TicketItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
      'status': _$TicketStatusEnumMap[instance.status],
    };

const _$TicketStatusEnumMap = {
  TicketStatus.PendingAdminResponse: 0,
  TicketStatus.PendingUserResponse: 1,
  TicketStatus.OnHold: 2,
  TicketStatus.GlobalIssue: 3,
  TicketStatus.Resolved: 4,
  TicketStatus.Closed: 5,
};

SupportModel _$SupportModelFromJson(Map<String, dynamic> json) => SupportModel()
  ..count = json['count'] as int?
  ..items = (json['items'] as List<dynamic>)
      .map((e) => SupportItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$SupportModelToJson(SupportModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
    };

SupportItem _$SupportItemFromJson(Map<String, dynamic> json) => SupportItem()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..displayName = json['display_name'] as String?
  ..ticketName = json['ticket_name'] as String?;

Map<String, dynamic> _$SupportItemToJson(SupportItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
      'ticket_name': instance.ticketName,
    };
