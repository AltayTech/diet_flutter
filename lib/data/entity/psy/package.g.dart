// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Package _$PackageFromJson(Map<String, dynamic> json) => Package()
  ..id = json['id'] as int?
  ..price = json['price'] == null
      ? null
      : packagePrice.fromJson(json['price'] as Map<String, dynamic>)
  ..time = json['time'] as int?;

Map<String, dynamic> _$PackageToJson(Package instance) => <String, dynamic>{
      'id': instance.id,
      'price': instance.price,
      'time': instance.time,
    };

packagePrice _$packagePriceFromJson(Map<String, dynamic> json) => packagePrice()
  ..price = json['price'] as int?
  ..finalPrice = json['final_price'] as int?
  ..currencyName = json['currency_name'] as String?
  ..currencyEnName = json['currency_en_name'] as String?;

Map<String, dynamic> _$packagePriceToJson(packagePrice instance) =>
    <String, dynamic>{
      'price': instance.price,
      'final_price': instance.finalPrice,
      'currency_name': instance.currencyName,
      'currency_en_name': instance.currencyEnName,
    };
