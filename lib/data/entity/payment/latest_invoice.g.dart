// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latest_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatestInvoiceData _$LatestInvoiceDataFromJson(Map<String, dynamic> json) =>
    LatestInvoiceData()
      ..amount = (json['amount'] as num?)?.toDouble()
      ..cardNumber = json['card_no'] as String?
      ..note = json['note'] as String?
      ..ownerName = json['owner_name'] as String?
      ..payedAt = json['payed_at'] as String?
      ..refId = json['ref_id'] as String?
      ..resolved = json['resolved'] as bool?
      ..success = json['success'] as bool?;

Map<String, dynamic> _$LatestInvoiceDataToJson(LatestInvoiceData instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'card_no': instance.cardNumber,
      'note': instance.note,
      'owner_name': instance.ownerName,
      'payed_at': instance.payedAt,
      'ref_id': instance.refId,
      'resolved': instance.resolved,
      'success': instance.success,
    };
