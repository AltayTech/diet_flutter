// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCode _$VerificationCodeFromJson(Map<String, dynamic> json) =>
    VerificationCode()
      ..mobile = json['mobile'] as String?
      ..channel = json['channel'] as String?
      ..verifyCode = json['verification_code'] as String?
      ..resetPass = json['reset_pass'] as bool?
      ..routeName = json['route_name'] as String?
      ..countryId = json['country_id'] as int?;

Map<String, dynamic> _$VerificationCodeToJson(VerificationCode instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'channel': instance.channel,
      'verification_code': instance.verifyCode,
      'reset_pass': instance.resetPass,
      'route_name': instance.routeName,
      'country_id': instance.countryId,
    };

VerifyOutput _$VerifyOutputFromJson(Map<String, dynamic> json) => VerifyOutput()
  ..verified = json['verified'] as bool?
  ..token = json['token'] as String?;

Map<String, dynamic> _$VerifyOutputToJson(VerifyOutput instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'token': instance.token,
    };
