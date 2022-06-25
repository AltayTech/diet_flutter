// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotifResponse _$NotifResponseFromJson(Map json) => NotifResponse()
  ..data = json['data'] == null
      ? null
      : Notif.fromJson(Map<String, dynamic>.from(json['data'] as Map));

Map<String, dynamic> _$NotifResponseToJson(NotifResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

Notif _$NotifFromJson(Map json) => Notif()
  ..channel_id = json['channel_id'] as String?
  ..description = json['description'] as String?
  ..autoCancel = json['auto_cancel'] as String?
  ..action = json['action'] as String?
  ..actions = (json['actions'] as List<dynamic>?)
      ?.map((e) => ActionsItem.fromJson(Map<String, dynamic>.from(e as Map)))
      .toList()
  ..package = json['package'] as String?
  ..data = json['data'] as String?
  ..icon = json['icon'] as String?
  ..title = json['title'] as String?
  ..visible = json['visible'] as String?
  ..actionType = json['actionType'] as String?
  ..layout =
      $enumDecodeNullable(_$NotificationLayoutEnumMap, json['layoutType']) ??
          NotificationLayout.Default;

Map<String, dynamic> _$NotifToJson(Notif instance) => <String, dynamic>{
      'channel_id': instance.channel_id,
      'description': instance.description,
      'auto_cancel': instance.autoCancel,
      'action': instance.action,
      'actions': instance.actions,
      'package': instance.package,
      'data': instance.data,
      'icon': instance.icon,
      'title': instance.title,
      'visible': instance.visible,
      'actionType': instance.actionType,
      'layoutType': _$NotificationLayoutEnumMap[instance.layout],
    };

const _$NotificationLayoutEnumMap = {
  NotificationLayout.Default: 'Default',
  NotificationLayout.BigPicture: 'BigPicture',
  NotificationLayout.BigText: 'BigText',
  NotificationLayout.Inbox: 'Inbox',
  NotificationLayout.ProgressBar: 'ProgressBar',
  NotificationLayout.Messaging: 'Messaging',
  NotificationLayout.MediaPlayer: 'MediaPlayer',
};

ActionsItem _$ActionsItemFromJson(Map json) => ActionsItem()
  ..title = json['title'] as String?
  ..actionType = json['action_type'] as String?
  ..action = json['action'] as String?
  ..key = json['key'] as String?;

Map<String, dynamic> _$ActionsItemToJson(ActionsItem instance) =>
    <String, dynamic>{
      'title': instance.title,
      'action_type': instance.actionType,
      'action': instance.action,
      'key': instance.key,
    };
