import 'package:json_annotation/json_annotation.dart';
part 'latest_invoice.g.dart';

@JsonSerializable()
class LatestInvoiceData {
  LatestInvoiceData();

  @JsonKey(name: 'amount')
  double? amount;

  @JsonKey(name: 'card_no')
  String? cardNumber;

  @JsonKey(name: 'note')
  String? note;

  @JsonKey(name: 'owner_name')
  String? ownerName;

  @JsonKey(name: 'payed_at')
  String? payedAt;

  @JsonKey(name: 'ref_id')
  String? refId;

  @JsonKey(name: 'resolved')
  bool? resolved;

  @JsonKey(name: 'success')
  bool? success;

  @JsonKey(name: 'card_owner')
  String? cardOwner;

  @JsonKey(name: 'card_number')
  String? cardNum;

  factory LatestInvoiceData.fromJson(Map<String, dynamic> json) =>
      _$LatestInvoiceDataFromJson(json);

  Map<String, dynamic> toJson() => _$LatestInvoiceDataToJson(this);
}