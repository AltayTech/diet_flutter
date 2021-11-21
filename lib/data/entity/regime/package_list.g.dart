// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageItem _$PackageItemFromJson(Map<String, dynamic> json) => PackageItem()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => PackageItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..isActive = json['is_active'] as int?
  ..id = json['id'] as int?
  ..price = json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..services = (json['services'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..index = json['index'] as int?;

Map<String, dynamic> _$PackageItemToJson(PackageItem instance) =>
    <String, dynamic>{
      'items': instance.items,
      'is_active': instance.isActive,
      'id': instance.id,
      'price': instance.price,
      'name': instance.name,
      'services': instance.services,
      'products': instance.products,
      'index': instance.index,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price()
  ..currencyName = json['currency_name'] as String?
  ..price = json['price'] as int?
  ..finalPrice = json['final_price'] as int?;

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'currency_name': instance.currencyName,
      'price': instance.price,
      'final_price': instance.finalPrice,
    };

ServicePackage _$ServicePackageFromJson(Map<String, dynamic> json) =>
    ServicePackage()
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..isActive = json['is_active'] as int?;

Map<String, dynamic> _$ServicePackageToJson(ServicePackage instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'is_active': instance.isActive,
    };
