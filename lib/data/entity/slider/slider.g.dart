// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slider _$SliderFromJson(Map<String, dynamic> json) => Slider()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => Slider.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..priority = json['priority'] as int?
  ..media = json['media'] == null
      ? null
      : Media.fromJson(json['media'] as Map<String, dynamic>);

Map<String, dynamic> _$SliderToJson(Slider instance) => <String, dynamic>{
      'items': instance.items,
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'priority': instance.priority,
      'media': instance.media,
    };
