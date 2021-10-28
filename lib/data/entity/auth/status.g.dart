// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckStatus _$CheckStatusFromJson(Map<String, dynamic> json) => CheckStatus()
  ..next = json['next'] as String?
  ..message = json['message'] as String?
  ..isExist = json['existed'] as bool?;

Map<String, dynamic> _$CheckStatusToJson(CheckStatus instance) =>
    <String, dynamic>{
      'next': instance.next,
      'message': instance.message,
      'existed': instance.isExist,
    };
