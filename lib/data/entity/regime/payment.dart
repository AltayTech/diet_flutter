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

  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "amount")
  int? amount;

  @JsonKey(name: "ref_id")
  String? ref_id;

  @JsonKey(name: "url")
  String? url;

  Payment();

  factory Payment.fromJson(Map<String, dynamic> json) => _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

@JsonSerializable()
class Invoice {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "amount")
  int? amount;

  @JsonKey(name: "ref_id")
  String? refId;

  @JsonKey(name: "resolved")
  bool? resolved;

  @JsonKey(name: "payed_at")
  String? payedAt;

  @JsonKey(name: "success")
  bool? success;

  @JsonKey(name: "card_no")
  String? cardNumber;

  @JsonKey(name: "owner_name")
  String? ownerName;

  Invoice();

  factory Invoice.fromJson(Map<String, dynamic> json) => _$InvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceToJson(this);
}
