import 'package:behandam/data/entity/psy/admin.dart';
import 'package:behandam/data/entity/psy/package.dart';
import 'package:behandam/data/entity/psy/plan.dart';
import 'package:json_annotation/json_annotation.dart';
part 'calender.g.dart';

@JsonSerializable()
class CalenderOutput {
  @JsonKey(name: "packages")
  List<Package>? packages;
  @JsonKey(name: "admins")
  List<Admin>? admins;
  @JsonKey(name: "dates")
  List<Plan>? dates;

  CalenderOutput();

  factory CalenderOutput.fromJson(Map<String, dynamic> json) => _$CalenderOutputFromJson(json);
  Map<String, dynamic> toJson() => _$CalenderOutputToJson(this);
}