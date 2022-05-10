import 'package:json_annotation/json_annotation.dart';

part 'subscription_term_data.g.dart';

@JsonSerializable(createToJson: false)
class SubscriptionTermData {
  @JsonKey(name: 'current_subscription_remaining_days')
  int? currentSubscriptionRemainingDays;

  @JsonKey(name: 'reserved_subscriptions_duration')
  int? reservedSubscriptionsDuration;

  SubscriptionTermData();

  factory SubscriptionTermData.fromJson(Map<String, dynamic> json) => _$SubscriptionTermDataFromJson(json);
}