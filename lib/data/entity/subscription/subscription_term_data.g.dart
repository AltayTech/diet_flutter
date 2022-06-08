// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subscription_term_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionTermData _$SubscriptionTermDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionTermData()
      ..currentSubscriptionRemainingDays =
          json['current_subscription_remaining_days'] as int?
      ..reservedSubscriptionsDuration =
          json['reserved_subscriptions_duration'] as int?
      ..pendingCardPayment = json['pending_card_payment'] == null
          ? null
          : SubscriptionPendingData.fromJson(
              json['pending_card_payment'] as Map<String, dynamic>);

SubscriptionPendingData _$SubscriptionPendingDataFromJson(
        Map<String, dynamic> json) =>
    SubscriptionPendingData()
      ..packageName = json['package_name'] as String
      ..createdAt = json['created_at'] as String
      ..termDays = json['term_days'] as int;
