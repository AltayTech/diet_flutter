// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerificationCode _$VerificationCodeFromJson(Map<String, dynamic> json) =>
    VerificationCode()
      ..mobile = json['mobile'] as String?
      ..verifyCode = json['verification_code'] as String?
      ..resetPass = json['reset_pass'] as bool?
      ..routeName = json['route_name'] as String?;

Map<String, dynamic> _$VerificationCodeToJson(VerificationCode instance) =>
    <String, dynamic>{
      'mobile': instance.mobile,
      'verification_code': instance.verifyCode,
      'reset_pass': instance.resetPass,
      'route_name': instance.routeName,
    };

VerifyOutput _$VerifyOutputFromJson(Map<String, dynamic> json) => VerifyOutput()
  ..verified = json['verified'] as bool?
  ..token = json['token'] == null
      ? null
      : VerifyOutput.fromJson(json['token'] as Map<String, dynamic>)
  ..accessToken = json['accessToken'] as String?;

Map<String, dynamic> _$VerifyOutputToJson(VerifyOutput instance) =>
    <String, dynamic>{
      'verified': instance.verified,
      'token': instance.token,
      'accessToken': instance.accessToken,
    };
