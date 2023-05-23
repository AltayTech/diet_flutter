// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CallSupport _$CallSupportFromJson(Map<String, dynamic> json) => CallSupport()
  ..firstName = json['first_name'] as String?
  ..supportEMobile = json['support_expert_mobile'] == null
      ? null
      : CallSupport.fromJson(
          json['support_expert_mobile'] as Map<String, dynamic>)
  ..lastName = json['last_name'] as String?
  ..mobile = json['mobile'] as String?;

Map<String, dynamic> _$CallSupportToJson(CallSupport instance) =>
    <String, dynamic>{
      'first_name': instance.firstName,
      'support_expert_mobile': instance.supportEMobile,
      'last_name': instance.lastName,
      'mobile': instance.mobile,
    };

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
