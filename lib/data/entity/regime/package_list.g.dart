// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => Package.fromJson(e as Map<String, dynamic>))
      .toList()
  ..servicesPackages = (json['services'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..price = json['price'] == null
      ? null
      : PackagePriceNew.fromJson(json['price'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..media = json['media'] as String?
  ..description = json['description'] as String?
  ..package_id = json['package_id'] as int?
  ..refundDeadline = json['refund_deadline'] as int? ?? 0
  ..type = json['payment_type_id'] as int?
  ..termDays = json['term_days'] as int?
  ..is_suggestion = json['is_suggestion'] as bool? ?? false
  ..index = json['index'] as int?
  ..totalPrice = json['totalPrice'] as int?
  ..isSelected = json['isSelected'] as bool? ?? false
  ..selectedDietTypeId = json[' selected_diet_type_id'] as int?;

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'items': instance.items,
      'services': instance.servicesPackages,
      'id': instance.id,
      'price': instance.price,
      'name': instance.name,
      'media': instance.media,
      'description': instance.description,
      'package_id': instance.package_id,
      'refund_deadline': instance.refundDeadline,
      'payment_type_id': instance.type,
      'term_days': instance.termDays,
      'is_suggestion': instance.is_suggestion,
      'index': instance.index,
      'totalPrice': instance.totalPrice,
      'isSelected': instance.isSelected,
      ' selected_diet_type_id': instance.selectedDietTypeId,
    };

PackageItem _$PackageItemFromJson(Map<String, dynamic> json) => PackageItem()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => PackageItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..services = (json['services'] as List<dynamic>?)
      ?.map((e) => ServicePackage.fromJson(e as Map<String, dynamic>))
      .toList()
  ..id = json['id'] as int?
  ..price = json['price'] == null
      ? null
      : PackagePrice.fromJson(json['price'] as Map<String, dynamic>)
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..media = json['media'] as String?
  ..package_id = json['package_id'] as int?
  ..refundDeadline = json['refund_deadline'] as int? ?? 0
  ..index = json['index'] as int?;

Map<String, dynamic> _$PackageItemToJson(PackageItem instance) =>
    <String, dynamic>{
      'items': instance.items,
      'services': instance.services,
      'id': instance.id,
      'price': instance.price,
      'name': instance.name,
      'description': instance.description,
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
  ..product_id = json['product_id'] as int?
  ..packageId = json['package_id'] as int?
  ..discount_message = json['discount_message'] as String?
  ..description = json['description'] as String?
  ..services =
      (json['service_ids'] as List<dynamic>?)?.map((e) => e as int).toList()
  ..selectedDietTypeId = json['selected_diet_type_id'] as int?;

Map<String, dynamic> _$PriceToJson(Price instance) => <String, dynamic>{
      'currency_name': instance.currencyName,
      'price': instance.price,
      'discount': instance.discount,
      'code': instance.code,
      'final_price': instance.finalPrice,
      'total_price': instance.totalPrice,
      'product_id': instance.product_id,
      'package_id': instance.packageId,
      'discount_message': instance.discount_message,
      'description': instance.description,
      'service_ids': instance.services,
      'selected_diet_type_id': instance.selectedDietTypeId,
    };

ServicePackage _$ServicePackageFromJson(Map<String, dynamic> json) =>
    ServicePackage()
      ..id = json['id'] as int?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..price = json['price'] == null
          ? null
          : PackagePriceNew.fromJson(json['price'] as Map<String, dynamic>)
      ..isSelected = json['isSelected'] as bool? ?? false
      ..days = json['days'] as int?;

Map<String, dynamic> _$ServicePackageToJson(ServicePackage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'isSelected': instance.isSelected,
      'days': instance.days,
    };

PackagePriceNew _$PackagePriceNewFromJson(Map<String, dynamic> json) =>
    PackagePriceNew()
      ..id = json['id'] as int?
      ..priceableId = json['priceable_id'] as int?
      ..price = json['amount'] as int? ?? 0
      ..finalPrice = json['sale_amount'] as int?
      ..type = json['type'] as int?
      ..totalPrice = json['totalPrice'] as int?;

Map<String, dynamic> _$PackagePriceNewToJson(PackagePriceNew instance) =>
    <String, dynamic>{
      'id': instance.id,
      'priceable_id': instance.priceableId,
      'amount': instance.price,
      'sale_amount': instance.finalPrice,
      'type': instance.type,
      'totalPrice': instance.totalPrice,
    };
