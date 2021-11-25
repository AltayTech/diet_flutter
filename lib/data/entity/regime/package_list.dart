import 'package:behandam/base/utils.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_list.g.dart';

@JsonSerializable()
class PackageItem {
  @JsonKey(name: "items")
  List<PackageItem>? items;

  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "price")
  Price? price;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "services")
  List<ServicePackage>? services;

  @JsonKey(name: "package_id")
  int? package_id;

  int? index;

  PackageItem();

  Color get barColor => Utils.getColorPackage(index!);

  Color get priceColor => Utils.getColorPackagePrice(index!);

  factory PackageItem.fromJson(Map<String, dynamic> json) => _$PackageItemFromJson(json);

  Map<String, dynamic> toJson() => _$PackageItemToJson(this);
}

@JsonSerializable()
class Price {
  @JsonKey(name: "currency_name")
  String? currencyName;
  @JsonKey(name: "price")
  int? price;
  @JsonKey(name: "discount")
  int? discount;
  @JsonKey(name: "code")
  String? code;
  @JsonKey(name: "final_price")
  int? finalPrice;

  int get priceDiscount => ((price ?? 0) - (finalPrice ?? 0));

  Price();

  factory Price.fromJson(Map<String, dynamic> json) => _$PriceFromJson(json);

  Map<String, dynamic> toJson() => _$PriceToJson(this);
}

@JsonSerializable()
class ServicePackage {
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "description")
  String? description;

  ServicePackage();

  factory ServicePackage.fromJson(Map<String, dynamic> json) => _$ServicePackageFromJson(json);

  Map<String, dynamic> toJson() => _$ServicePackageToJson(this);
}
