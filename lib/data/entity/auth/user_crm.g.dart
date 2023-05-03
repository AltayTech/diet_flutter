// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_crm.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCrm _$UserCrmFromJson(Map<String, dynamic> json) => UserCrm()
  ..mobile = json['mobile'] as String?
  ..firstName = json['first_name'] as String?
  ..lastName = json['last_name'] as String?
  ..topic = json['topic'] as int?
  ..repository = json['repository'] as int?
  ..country = json['country'] as String?;

Map<String, dynamic> _$UserCrmToJson(UserCrm instance) => <String, dynamic>{
      'mobile': instance.mobile,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'topic': instance.topic,
      'repository': instance.repository,
      'country': instance.country,
    };

UserCrmResponse _$UserCrmResponseFromJson(Map<String, dynamic> json) =>
    UserCrmResponse()..message = json['message'] as String?;

Map<String, dynamic> _$UserCrmResponseToJson(UserCrmResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
    };
