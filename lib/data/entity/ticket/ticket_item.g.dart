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
  ..createdAt = json['created_at'] as String?;

Map<String, dynamic> _$TicketItemToJson(TicketItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
    };
