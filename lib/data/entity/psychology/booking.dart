import 'package:json_annotation/json_annotation.dart';
part 'booking.g.dart';

@JsonSerializable()
class Booking {
  @JsonKey(name: "expert_planning_id")
  int? expertPlanningId;
  @JsonKey(name: "payment_type_id")
  int? paymentTypeId;
  @JsonKey(name: "package_id")
  int? packageId;
  @JsonKey(name: "origin_id")
  int? originId;

  Booking();

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}

@JsonSerializable()
class BookingOutput {
  @JsonKey(name: "url")
  String? url;
  @JsonKey(name: "message")
  String? message;

  BookingOutput();

  factory BookingOutput.fromJson(Map<String, dynamic> json) => _$BookingOutputFromJson(json);
  Map<String, dynamic> toJson() => _$BookingOutputToJson(this);
}