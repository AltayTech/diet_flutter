// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refund.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefundItem _$RefundItemFromJson(Map<String, dynamic> json) => RefundItem()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => RefundItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..refundStatus = json['status'] == null
      ? null
      : RefundStatus.fromJson(json['status'] as Map<String, dynamic>);

Map<String, dynamic> _$RefundItemToJson(RefundItem instance) =>
    <String, dynamic>{
      'items': instance.items,
      'status': instance.refundStatus,
    };

RefundStatus _$RefundStatusFromJson(Map<String, dynamic> json) =>
    RefundStatus()..text = json['text'] as String?;

Map<String, dynamic> _$RefundStatusToJson(RefundStatus instance) =>
    <String, dynamic>{
      'text': instance.text,
    };

RefundVerify _$RefundVerifyFromJson(Map<String, dynamic> json) => RefundVerify()
  ..shebaNumber = json['sheba_number'] as String?
  ..cardOwner = json['card_owner'] as String?;

Map<String, dynamic> _$RefundVerifyToJson(RefundVerify instance) =>
    <String, dynamic>{
      'sheba_number': instance.shebaNumber,
      'card_owner': instance.cardOwner,
    };
