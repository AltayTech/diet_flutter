// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Call _$CallFromJson(Map<String, dynamic> json) => Call()
  ..totalCallNumber = json['total_call_num'] as int?
  ..remainingCallNumber = json['remaining_call_num'] as int?
  ..count = json['count'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => CallItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$CallToJson(Call instance) => <String, dynamic>{
      'total_call_num': instance.totalCallNumber,
      'remaining_call_num': instance.remainingCallNumber,
      'count': instance.count,
      'items': instance.items,
    };

CallItem _$CallItemFromJson(Map<String, dynamic> json) => CallItem()
  ..id = json['id'] as int?
  ..done = json['done'] as bool? ?? false
  ..isReserve = json['is_reserve'] as bool?;

Map<String, dynamic> _$CallItemToJson(CallItem instance) => <String, dynamic>{
      'id': instance.id,
      'done': instance.done,
      'is_reserve': instance.isReserve,
    };
