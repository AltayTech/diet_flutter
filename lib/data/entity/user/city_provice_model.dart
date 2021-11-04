import 'package:json_annotation/json_annotation.dart';

part 'city_provice_model.g.dart';

@JsonSerializable()
class CityProvinceModel {
  @JsonKey(name: "cities")
  late List<CityProvince> allCities;

  @JsonKey(name: "provinces")
  late List<CityProvince> provinces;

  @JsonKey(name: "all_cities")
  List<CityProvince>? cities;

  CityProvinceModel();

  factory CityProvinceModel.fromJson(Map<String, dynamic> json) =>
      _$CityProvinceModelFromJson(json);

  Map<String, dynamic> toJson() => _$CityProvinceModelToJson(this);
}

@JsonSerializable()
class CityProvince {
  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "id")
  late int id;

  @JsonKey(name: "province_id")
  int? provinceId;

  CityProvince();

  factory CityProvince.fromJson(Map<String, dynamic> json) => _$CityProvinceFromJson(json);

  Map<String, dynamic> toJson() => _$CityProvinceToJson(this);
}
