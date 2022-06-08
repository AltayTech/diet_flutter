import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  @JsonKey(name: "coupon")
  String? coupon;

  @JsonKey(name: "payment_type_id")
  int? paymentTypeId;

  @JsonKey(name: "origin_id")
  int? originId;

  @JsonKey(name: "product_id")
  int? productId;

  @JsonKey(name: 'payed_at')
  String? payedAt;

  @JsonKey(name: 'card_owner')
  String? cardOwner;

  @JsonKey(name: 'card_number')
  String? cardNum;

  @JsonKey(name: "package_id")
  int? packageId;

  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "amount")
  int? amount;

  @JsonKey(name: "ref_id")
  String? ref_id;

  @JsonKey(name: "url")
  String? url;

  Payment();

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
