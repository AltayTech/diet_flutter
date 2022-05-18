
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/subscription/subscription_term_data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_subscription.g.dart';

@JsonSerializable(createToJson: false)
class ListUserSubscriptionData {
  ListUserSubscriptionData();

  @JsonKey(name: 'count')
  int? count;

  @JsonKey(name: 'subscription_list')
  List<SubscriptionsItems>? subscriptionList;

  @JsonKey(name: 'pending_card_payment')
  SubscriptionPendingData? pendingCardPayment;

  @JsonKey(name: 'sums')
  int? sums;

  factory ListUserSubscriptionData.fromJson(Map<String, dynamic> json) =>
      _$ListUserSubscriptionDataFromJson(json);
}

@JsonSerializable()
class SubscriptionsItems {
  SubscriptionsItems(
      this.packageId,
      this.paymentId,
      this.isActive,
      this.createdAt,
      this.packageName,
      this.paymentAmount
      );

  @JsonKey(name: 'package_id')
  int? packageId;

  @JsonKey(name: 'payment_id')
  int? paymentId;

  @JsonKey(name: 'is_active')
  int? isActive;

  @JsonKey(name: 'created_at')
  String? createdAt;

  @JsonKey(name: 'package_name')
  String? packageName;

  @JsonKey(name: 'payment_amount')
  int? paymentAmount;

  factory SubscriptionsItems.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionsItemsFromJson(json);

  Map<String, dynamic> toJson() => _$SubscriptionsItemsToJson(this);
}

