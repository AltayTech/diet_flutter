// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inbox.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Inbox _$InboxFromJson(Map<String, dynamic> json) => Inbox()
  ..count = json['inbox_count'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => InboxItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$InboxToJson(Inbox instance) => <String, dynamic>{
      'inbox_count': instance.count,
      'items': instance.items,
    };

InboxItem _$InboxItemFromJson(Map<String, dynamic> json) => InboxItem()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..text = json['text'] as String?
  ..createdAt = json['created_at'] as String?
  ..seenAt = json['seen_at'] as String?
  ..inbox = json['inbox'] == null
      ? null
      : InboxItem.fromJson(json['inbox'] as Map<String, dynamic>)
  ..actionType =
      $enumDecodeNullable(_$INBOX_ACTION_TYPEEnumMap, json['action_type'])
  ..action = json['action'] as String?;

Map<String, dynamic> _$InboxItemToJson(InboxItem instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'text': instance.text,
      'created_at': instance.createdAt,
      'seen_at': instance.seenAt,
      'inbox': instance.inbox,
      'action_type': _$INBOX_ACTION_TYPEEnumMap[instance.actionType],
      'action': instance.action,
    };

const _$INBOX_ACTION_TYPEEnumMap = {
  INBOX_ACTION_TYPE.OPEN_WEB_URL: 0,
  INBOX_ACTION_TYPE.OPEN_ESPECIAL_APP: 1,
  INBOX_ACTION_TYPE.OPEN_PAGE: 2,
  INBOX_ACTION_TYPE.OPEN_TELEGRAM_CHANNEL: 3,
  INBOX_ACTION_TYPE.OPEN_INSTAGRAM_PAGE: 4,
  INBOX_ACTION_TYPE.CALL_SERVICE: 5,
};
