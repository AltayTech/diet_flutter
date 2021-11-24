import 'package:json_annotation/json_annotation.dart';
part 'package.g.dart';

@JsonSerializable()
class Package {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "price")
  packagePrice? price;
  @JsonKey(name: "time")
  int? time;

  Package();

  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);
  Map<String, dynamic> toJson() => _$PackageToJson(this);
}

@JsonSerializable()
class packagePrice {
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "final_price")
  int? finalPrice;
  @JsonKey(name: "currency_name")
  String? currencyName;
  @JsonKey(name: "currency_en_name")
  String? currencyEnName;

  packagePrice();

  factory packagePrice.fromJson(Map<String, dynamic> json) => _$packagePriceFromJson(json);
  Map<String, dynamic> toJson() => _$packagePriceToJson(this);
}