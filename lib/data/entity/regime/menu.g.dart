// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuData _$MenuDataFromJson(Map<String, dynamic> json) => MenuData(
      json['count'] as int,
      (json['items'] as List<dynamic>)
          .map((e) => MenuType.fromJson(e as Map<String, dynamic>))
          .toList(),
      json['sum'] as int,
    );

MenuType _$MenuTypeFromJson(Map<String, dynamic> json) => MenuType(
      json['id'] as int,
      json['order'] as int,
      json['title'] as String,
      (json['menus'] as List<dynamic>)
          .map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
