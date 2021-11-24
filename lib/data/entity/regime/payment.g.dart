// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment()
  ..coupon = json['coupon'] as String?
  ..paymentTypeId = json['payment_type_id'] as int?
  ..originId = json['origin_id'] as int?
  ..id = json['id'] as int?
  ..amount = json['amount'] as int?
  ..ref_id = json['ref_id'] as String?
  ..url = json['url'] as String?;

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'coupon': instance.coupon,
      'payment_type_id': instance.paymentTypeId,
      'origin_id': instance.originId,
      'id': instance.id,
      'amount': instance.amount,
      'ref_id': instance.ref_id,
      'url': instance.url,
    };

Invoice _$InvoiceFromJson(Map<String, dynamic> json) => Invoice()
  ..id = json['id'] as int?
  ..amount = json['amount'] as int?
  ..refId = json['ref_id'] as String?
  ..resolved = json['resolved'] as bool?
  ..payedAt = json['payed_at'] as String?
  ..success = json['success'] as bool?
  ..cardNumber = json['card_no'] as String?
  ..ownerName = json['owner_name'] as String?;

Map<String, dynamic> _$InvoiceToJson(Invoice instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'ref_id': instance.refId,
      'resolved': instance.resolved,
      'payed_at': instance.payedAt,
      'success': instance.success,
      'card_no': instance.cardNumber,
      'owner_name': instance.ownerName,
    };
