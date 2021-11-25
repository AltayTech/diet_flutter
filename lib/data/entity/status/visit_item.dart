import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'visit_item.g.dart';

@JsonSerializable()
class VisitItem {
  VisitItem();

  @JsonKey(name: 'diet_type')
  RegimeAlias? dietType;

  @JsonKey(name: 'physical_info')
  PhysicalInfoData? physicalInfo;

  @JsonKey(name: 'visits')
  List<dynamic>? visits;

  @JsonKey(name: 'weight_difference')
  double? weightDifference;

  factory VisitItem.fromJson(Map<String, dynamic> json) => _$VisitItemFromJson(json);

  Map<String, dynamic> toJson() => _$VisitItemToJson(this);
}
