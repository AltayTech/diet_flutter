// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel()
  ..count = json['count'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => TicketItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..ticket = json['ticket'] == null
      ? null
      : TicketItem.fromJson(json['ticket'] as Map<String, dynamic>)
  ..files = (json['files'] as List<dynamic>?)
      ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
      .toList()
  ..createdAt = json['created_at'] as String?;

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
      'ticket': instance.ticket,
      'files': instance.files,
      'created_at': instance.createdAt,
    };

TicketItem _$TicketItemFromJson(Map<String, dynamic> json) => TicketItem()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..createdAt = json['created_at'] as String?
  ..status = $enumDecodeNullable(_$TicketStatusEnumMap, json['status'])
  ..messages = (json['messages'] as List<dynamic>?)
      ?.map((e) => MessageTicket.fromJson(e as Map<String, dynamic>))
      .toList()
  ..files = (json['files'] as List<dynamic>?)
      ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TicketItemToJson(TicketItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'created_at': instance.createdAt,
      'status': _$TicketStatusEnumMap[instance.status],
      'messages': instance.messages,
      'files': instance.files,
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
  ..ticketName = json['ticket_name'] as String?
  ..selected = json['selected'] as bool?;

Map<String, dynamic> _$SupportItemToJson(SupportItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'display_name': instance.displayName,
      'ticket_name': instance.ticketName,
      'selected': instance.selected,
    };

SendTicket _$SendTicketFromJson(Map<String, dynamic> json) => SendTicket()
  ..departmentId = json['department_id'] as int?
  ..body = json['body'] as String?
  ..title = json['title'] as String?
  ..hasAttachment = json['has_attachment'] as bool? ?? false
  ..isVoice = json['is_voice'] as bool? ?? false
  ..ticketId = json['ticket_id'] as int?;

Map<String, dynamic> _$SendTicketToJson(SendTicket instance) =>
    <String, dynamic>{
      'department_id': instance.departmentId,
      'body': instance.body,
      'title': instance.title,
      'has_attachment': instance.hasAttachment,
      'is_voice': instance.isVoice,
      'ticket_id': instance.ticketId,
    };

MessageTicket _$MessageTicketFromJson(Map<String, dynamic> json) =>
    MessageTicket()
      ..id = json['id'] as int?
      ..ticketId = json['ticket_id'] as int?
      ..body = json['body'] as String?
      ..type = $enumDecodeNullable(_$TypeTicketMessageEnumMap, json['type'])
      ..isAdmin = json['is_admin'] as int?
      ..isVoice = json['is_voice'] as int?
      ..file = (json['file'] as List<dynamic>?)
          ?.map((e) => Media.fromJson(e as Map<String, dynamic>))
          .toList()
      ..temp = json['template'] == null
          ? null
          : TempTicket.fromJson(json['template'] as Map<String, dynamic>)
      ..createdAt = json['created_at'] as String?;

Map<String, dynamic> _$MessageTicketToJson(MessageTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_id': instance.ticketId,
      'body': instance.body,
      'type': _$TypeTicketMessageEnumMap[instance.type],
      'is_admin': instance.isAdmin,
      'is_voice': instance.isVoice,
      'file': instance.file,
      'template': instance.temp,
      'created_at': instance.createdAt,
    };

const _$TypeTicketMessageEnumMap = {
  TypeTicketMessage.TEXT: 0,
  TypeTicketMessage.TEXT_AND_ATTACHMENT: 1,
  TypeTicketMessage.VOICE: 2,
  TypeTicketMessage.TEMP: 3,
};

TempItem _$TempItemFromJson(Map<String, dynamic> json) => TempItem()
  ..id = json['id'] as int?
  ..alterText = json['alter_text'] as String?
  ..media = (json['media'] as List<dynamic>?)
      ?.map((e) => TempMedia.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TempItemToJson(TempItem instance) => <String, dynamic>{
      'id': instance.id,
      'alter_text': instance.alterText,
      'media': instance.media,
    };

TempTicket _$TempTicketFromJson(Map<String, dynamic> json) => TempTicket()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..data = (json['data'] as List<dynamic>?)
      ?.map((e) => TempItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$TempTicketToJson(TempTicket instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'data': instance.data,
    };

TempMedia _$TempMediaFromJson(Map<String, dynamic> json) => TempMedia()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..fileName = json['file_name'] as String?
  ..mediumType = $enumDecodeNullable(_$MediumTypeEnumMap, json['medium_type'])
  ..mediumUrls = json['medium_urls'] == null
      ? null
      : Media.fromJson(json['medium_urls'] as Map<String, dynamic>)
  ..progress = json['progress'] as bool?;

Map<String, dynamic> _$TempMediaToJson(TempMedia instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'medium_type': _$MediumTypeEnumMap[instance.mediumType],
      'medium_urls': instance.mediumUrls,
      'progress': instance.progress,
    };

const _$MediumTypeEnumMap = {
  MediumType.IMAGE: 0,
  MediumType.VIDEO: 1,
  MediumType.NONE: 2,
  MediumType.AUDIO: 3,
  MediumType.file: 4,
};
