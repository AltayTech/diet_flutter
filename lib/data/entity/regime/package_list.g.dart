// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackageItem _$PackageItemFromJson(Map<String, dynamic> json) => PackageItem()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => PackageItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..price = json['price'] == null
      ? null
      : Price.fromJson(json['price'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..services = (json['services'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..package_id = json['package_id'] as int?
  ..refundDeadline = json['refund_deadline'] as int? ?? 0
  ..index = json['index'] as int?;

Map<String, dynamic> _$PackageItemToJson(PackageItem instance) =>
    <String, dynamic>{
      'items': instance.items,
      'id': instance.id,
      'price': instance.price,
      'name': instance.name,
      'services': instance.services,
      'package_id': instance.package_id,
      'refund_deadline': instance.refundDeadline,
      'index': instance.index,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price()
  ..currencyName = json['currency_name'] as String?
  ..price = json['price'] as int?
  ..discount = json['discount'] as int?
  ..code = json['code'] as String?
  ..finalPrice = json['final_price'] as int?
  ..totalPrice = json['total_price'] as int?;

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'currency_name': instance.currencyName,
      'price': instance.price,
      'discount': instance.discount,
      'code': instance.code,
      'final_price': instance.finalPrice,
      'total_price': instance.totalPrice,
    };

ServicePackage _$ServicePackageFromJson(Map<String, dynamic> json) =>
    ServicePackage()
      ..name = json['name'] as String?
      ..description = json['description'] as String?;

Map<String, dynamic> _$ServicePackageToJson(ServicePackage instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
    };
