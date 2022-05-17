import 'package:json_annotation/json_annotation.dart';

part 'subscription_term_data.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTermData {
  @JsonKey(name: 'current_subscription_remaining_days')
  int? currentSubscriptionRemainingDays;

  @JsonKey(name: 'reserved_subscriptions_duration')
  int? reservedSubscriptionsDuration;

  @JsonKey(name: 'pending_card_payment')
  SubscriptionPendingData? pendingCardPayment;

  SubscriptionTermData();

  factory SubscriptionTermData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionTermDataFromJson(json);
}

@JsonSerializable(createToJson: false)
class SubscriptionPendingData {
  @JsonKey(name: 'package_name')
  late String packageName;

  @JsonKey(name: 'created_at')
  late String createdAt;

  @JsonKey(name: 'term_days')
  late int termDays;

  SubscriptionPendingData();

  factory SubscriptionPendingData.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionPendingDataFromJson(json);
}
