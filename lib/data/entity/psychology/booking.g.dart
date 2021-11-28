// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking()
  ..expertPlanningId = json['expert_planning_id'] as int?
  ..paymentTypeId = json['payment_type_id'] as int?
  ..packageId = json['package_id'] as int?
  ..originId = json['origin_id'] as int?;

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
      'expert_planning_id': instance.expertPlanningId,
      'payment_type_id': instance.paymentTypeId,
      'package_id': instance.packageId,
      'origin_id': instance.originId,
    };

BookingOutput _$BookingOutputFromJson(Map<String, dynamic> json) =>
    BookingOutput()
      ..url = json['url'] as String?
      ..message = json['message'] as String?;

Map<String, dynamic> _$BookingOutputToJson(BookingOutput instance) =>
    <String, dynamic>{
      'url': instance.url,
      'message': instance.message,
    };
