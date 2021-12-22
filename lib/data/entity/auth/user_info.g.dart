// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..mobile = json['mobile'] as String?
  ..password = json['password'] as String?
  ..code = json['verification_code'] as String?
  ..routeName = json['route_name'] as String?;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'mobile': instance.mobile,
      'password': instance.password,
      'verification_code': instance.code,
      'route_name': instance.routeName,
    };
