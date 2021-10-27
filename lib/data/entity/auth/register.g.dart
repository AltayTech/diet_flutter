// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Register _$RegisterFromJson(Map<String, dynamic> json) => Register()
  ..firstName = json['first_name'] as String?
  ..lastName = json['last_name'] as String?
  ..mobile = json['mobile'] as String?
  ..password = json['password'] as String?
  ..verifyCode = json['code'] as String?
  ..gender = json['gender'] as int?
  ..countryId = json['country_id'] as int?;

Map<String, dynamic> _$RegisterToJson(Register instance) => <String, dynamic>{
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'mobile': instance.mobile,
      'password': instance.password,
      'code': instance.verifyCode,
      'gender': instance.gender,
      'country_id': instance.countryId,
    };

RegisterOutput _$RegisterOutputFromJson(Map<String, dynamic> json) =>
    RegisterOutput()..token = json['token'] as String?;

Map<String, dynamic> _$RegisterOutputToJson(RegisterOutput instance) =>
    <String, dynamic>{
      'token': instance.token,
    };
