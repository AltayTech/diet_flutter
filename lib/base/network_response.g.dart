// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NetworkResponse<T> _$NetworkResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    NetworkResponse<T>()
      ..error = json['error'] == null
          ? null
          : ErrorResponse.fromJson(json['error'] as Map<String, dynamic>)
      ..message = json['message'] as String?
      ..next = json['next'] as String?
      ..remainingTime = json['remaining_time'] as String?
      ..data = _$nullableGenericFromJson(json['data'], fromJsonT);

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) =>
    input == null ? null : fromJson(input);

ErrorResponse _$ErrorResponseFromJson(Map<String, dynamic> json) =>
    ErrorResponse()..message = json['message'] as String?;

Map<String, dynamic> _$ErrorResponseToJson(ErrorResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
