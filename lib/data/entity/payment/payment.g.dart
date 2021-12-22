// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment()
  ..coupon = json['coupon'] as String?
  ..paymentTypeId = json['payment_type_id'] as int?
  ..originId = json['origin_id'] as int?
  ..productId = json['product_id'] as int?
  ..id = json['id'] as int?
  ..amount = json['amount'] as int?
  ..ref_id = json['ref_id'] as String?
  ..url = json['url'] as String?;

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'coupon': instance.coupon,
      'payment_type_id': instance.paymentTypeId,
      'origin_id': instance.originId,
      'product_id': instance.productId,
      'id': instance.id,
      'amount': instance.amount,
      'ref_id': instance.ref_id,
      'url': instance.url,
    };
