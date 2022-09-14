// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'block_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BlockUser _$BlockUserFromJson(Map<String, dynamic> json) => BlockUser()
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => BlockUser.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$BlockUserToJson(BlockUser instance) => <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'items': instance.items,
    };
