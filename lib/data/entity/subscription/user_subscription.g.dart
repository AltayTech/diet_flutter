// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_subscription.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ListUserSubscriptionData _$ListUserSubscriptionDataFromJson(
        Map<String, dynamic> json) =>
    ListUserSubscriptionData()
      ..count = json['count'] as int?
      ..items = json['items'] == null
          ? null
          : ListUserSubscriptionData.fromJson(
              json['items'] as Map<String, dynamic>)
      ..subscriptionList = (json['subscription_list'] as List<dynamic>?)
          ?.map((e) => SubscriptionsItems.fromJson(e as Map<String, dynamic>))
          .toList()
      ..sums = json['sums'] as int?;

SubscriptionsItems _$SubscriptionsItemsFromJson(Map<String, dynamic> json) =>
    SubscriptionsItems(
      json['package_id'] as int?,
      json['payment_id'] as int?,
      json['is_active'] as int?,
      json['created_at'] as String?,
      json['package_name'] as String?,
      json['payment_amount'] as int?,
    );

Map<String, dynamic> _$SubscriptionsItemsToJson(SubscriptionsItems instance) =>
    <String, dynamic>{
      'package_id': instance.packageId,
      'payment_id': instance.paymentId,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'package_name': instance.packageName,
      'payment_amount': instance.paymentAmount,
    };
