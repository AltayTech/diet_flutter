// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admin _$AdminFromJson(Map<String, dynamic> json) => Admin()
  ..adminId = json['admin_id'] as int?
  ..image = json['image'] as String?
  ..name = json['name'] as String?
  ..role = json['role'] as String?
  ..packageId = json['package_id'] as int?;

Map<String, dynamic> _$AdminToJson(Admin instance) => <String, dynamic>{
      'admin_id': instance.adminId,
      'image': instance.image,
      'name': instance.name,
      'role': instance.role,
      'package_id': instance.packageId,
    };
