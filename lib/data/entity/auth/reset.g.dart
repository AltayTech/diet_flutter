// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reset.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reset _$ResetFromJson(Map<String, dynamic> json) =>
    Reset()..password = json['password'] as String?;

Map<String, dynamic> _$ResetToJson(Reset instance) => <String, dynamic>{
      'password': instance.password,
    };

ResetOutput _$ResetOutputFromJson(Map<String, dynamic> json) =>
    ResetOutput()..token = json['token'] as String?;

Map<String, dynamic> _$ResetOutputToJson(ResetOutput instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
