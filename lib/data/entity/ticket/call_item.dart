import 'package:json_annotation/json_annotation.dart';

part 'call_item.g.dart';

enum UiCallType { None, Reserve, Reserved, Done }

@JsonSerializable()
class CallSupport {
  @JsonKey(name: "first_name")
  String? firstName;

  @JsonKey(name: "support_expert_mobile")
  CallSupport? supportEMobile;

  @JsonKey(name: "last_name")
  String? lastName;

  @JsonKey(name: "mobile")
  String? mobile;


  CallSupport();

  factory CallSupport.fromJson(Map<String, dynamic> json) => _$CallSupportFromJson(json);

  Map<String, dynamic> toJson() => _$CallSupportToJson(this);
}

@JsonSerializable()
class Call {
  @JsonKey(name: "total_call_num")
  int? totalCallNumber;

  @JsonKey(name: "remaining_call_num")
  int? remainingCallNumber;

  @JsonKey(name: "count")
  int? count;

  @JsonKey(name: "items")
  List<CallItem>? items;


  Call();

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);

  Map<String, dynamic> toJson() => _$CallToJson(this);
}

@JsonSerializable()
class CallItem {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "done", defaultValue: false)
  bool? done;

  @JsonKey(name: "is_reserve")
  bool? isReserve;

  UiCallType get callType => getCallType();

  UiCallType getCallType() {
    if (isReserve == null && !done!) {
      return UiCallType.Reserved;
    } else if (isReserve != null && isReserve!) {
      return UiCallType.Reserve;
    } else if (isReserve == null && done!) {
      return UiCallType.Done;
    } else {
      return UiCallType.None;
    }
  }

  CallItem();

  factory CallItem.fromJson(Map<String, dynamic> json) => _$CallItemFromJson(json);

  Map<String, dynamic> toJson() => _$CallItemToJson(this);
}
