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
      : PackagePrice.fromJson(json['price'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..services = (json['services'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..media = json['media'] as String?
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
      'media': instance.media,
      'package_id': instance.package_id,
      'refund_deadline': instance.refundDeadline,
      'index': instance.index,
    };

PackagePrice _$PackagePriceFromJson(Map<String, dynamic> json) => PackagePrice()
  ..id = json['id'] as int?
  ..priceableId = json['priceable_id'] as int?
  ..amount = json['amount'] as int?
  ..saleAmount = json['sale_amount'] as int?
  ..type = json['type'] as int?
  ..totalPrice = json['totalPrice'] as int?;

Map<String, dynamic> _$PackagePriceToJson(PackagePrice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'priceable_id': instance.priceableId,
      'amount': instance.amount,
      'sale_amount': instance.saleAmount,
      'type': instance.type,
      'totalPrice': instance.totalPrice,
    };

Price _$PriceFromJson(Map<String, dynamic> json) => Price()
  ..currencyName = json['currency_name'] as String?
  ..price = json['price'] as int?
  ..discount = json['discount'] as int?
  ..code = json['code'] as String?
  ..finalPrice = json['final_price'] as int?
  ..totalPrice = json['total_price'] as int?
  ..product_id = json['product_id'] as int?;

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'currency_name': instance.currencyName,
      'price': instance.price,
      'discount': instance.discount,
      'code': instance.code,
      'final_price': instance.finalPrice,
      'total_price': instance.totalPrice,
      'product_id': instance.product_id,
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
