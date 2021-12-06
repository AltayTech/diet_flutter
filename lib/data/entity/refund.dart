import 'package:json_annotation/json_annotation.dart';

part 'refund.g.dart';

@JsonSerializable()
class RefundItem {
  @JsonKey(name: "items")
  List<RefundItem>? items;

  @JsonKey(name: "status")
  RefundStatus? refundStatus;

  RefundItem();

  factory RefundItem.fromJson(Map<String, dynamic> json) => _$RefundItemFromJson(json);

  Map<String, dynamic> toJson() => _$RefundItemToJson(this);
}

@JsonSerializable()
class RefundStatus {
  @JsonKey(name: "text")
  String? text;

  RefundStatus();

  factory RefundStatus.fromJson(Map<String, dynamic> json) => _$RefundStatusFromJson(json);

  Map<String, dynamic> toJson() => _$RefundStatusToJson(this);
}

@JsonSerializable()
class RefundVerify {
  @JsonKey(name: "card_number")
  String? cardNumber;

  @JsonKey(name: "card_owner")
  String? cardOwner;

  RefundVerify();

  factory RefundVerify.fromJson(Map<String, dynamic> json) => _$RefundVerifyFromJson(json);

  Map<String, dynamic> toJson() => _$RefundVerifyToJson(this);
}
