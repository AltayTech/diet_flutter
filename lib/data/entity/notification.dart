import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable(anyMap: true)
class NotifResponse {
  @JsonKey(name: "data")
  Notif? data;

  NotifResponse();

  factory NotifResponse.fromJson(Map<String, dynamic> json) => _$NotifResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotifResponseToJson(this);
}

@JsonSerializable(anyMap: true)
class Notif {
  @JsonKey(name: "channel_id")
  String? channel_id;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "auto_cancel")
  String? autoCancel;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "actions")
  List<ActionsItem>? actions;
  @JsonKey(name: "package")
  String? package;
  @JsonKey(name: "data")
  String? data;
  @JsonKey(name: "icon")
  String? icon;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "visible")
  String? visible;
  @JsonKey(name: "actionType")
  String? actionType;

  @JsonKey(name: "layoutType", defaultValue: NotificationLayout.Default)
  NotificationLayout? layout;

  Notif();

  factory Notif.fromJson(Map<String, dynamic> json) => Notif()
    ..channel_id = json['channel_id'] as String?
    ..description = json['description'] as String?
    ..autoCancel = json['auto_cancel'] as String?
    ..action = json['action'] as String?
    ..package = json['package'] as String?
    ..data = json['data'] as String?
    ..icon = json['icon'] as String?
    ..title = json['title'] as String?
    ..visible = json['visible'] as String?
    ..layout = $enumDecodeNullable(_$ActionTypeEnumMap, json['layoutType'])
    ..actionType = json['action_type'] as String?
    ..actions = (jsonDecode(json['actions']) as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : ActionsItem.fromJson((e as Map).map(
                (k, e) => MapEntry(k as String, e),
              )))
        .cast<ActionsItem>()
        .toList();

  factory Notif.fromJson2(Map<String, dynamic> json) => Notif()
    ..channel_id = json['channel_id'] as String?
    ..description = json['description'] as String?
    ..autoCancel = json['auto_cancel'] as String?
    ..action = json['action'] as String?
    ..package = json['package'] as String?
    ..data = json['data'] as String?
    ..icon = json['icon'] as String?
    ..title = json['title'] as String?
    ..visible = json['visible'] as String?
    ..layout = $enumDecodeNullable(_$ActionTypeEnumMap, json['layoutType'])
    ..actionType = json['action_type'] as String?
    ..actions = (json['actions'] as List<dynamic>?)
        ?.map((e) => e == null
            ? null
            : ActionsItem.fromJson((e as Map).map(
                (k, e) => MapEntry(k as String, e),
              )))
        .cast<ActionsItem>()
        .toList();

  Map<String, dynamic> toJson() => _$NotifToJson(this);
}

const _$ActionTypeEnumMap = {
  NotificationLayout.Default: '0',
  NotificationLayout.BigPicture: '1',
  NotificationLayout.BigText: '2',
  NotificationLayout.Inbox: '3',
  NotificationLayout.ProgressBar: '4',
  NotificationLayout.Messaging: '5',
  NotificationLayout.MediaPlayer: '6',
};

@JsonSerializable(anyMap: true)
class ActionsItem {
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "action_type")
  String? actionType;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "key")
  String? key;

  ActionsItem();

  factory ActionsItem.fromJson(Map<String, dynamic> json) => _$ActionsItemFromJson(json);

  Map<String, dynamic> toJson() => _$ActionsItemToJson(this);
}
