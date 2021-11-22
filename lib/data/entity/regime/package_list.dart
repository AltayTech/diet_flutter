import 'package:behandam/base/utils.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_list.g.dart';

@JsonSerializable()
class PackageItem {
  @JsonKey(name: "items")
  List<PackageItem>? items;

  @JsonKey(name: "is_active")
  int? isActive;
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "price")
  Price? price;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "services")
  List<ServicePackage>? services;

  @JsonKey(name: "products")
  List<ServicePackage>? products;

  @JsonKey(name: "package_id")
  int? package_id;

  int? index;

  PackageItem();

  bool get isActiveItem => isActive == 1;

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
  @JsonKey(name: "final_price")
  int? finalPrice;

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
  @JsonKey(name: "is_active")
  int? isActive;

  ServicePackage();

  bool get isActiveItem => isActive == 1;

  factory ServicePackage.fromJson(Map<String, dynamic> json) => _$ServicePackageFromJson(json);

  Map<String, dynamic> toJson() => _$ServicePackageToJson(this);
}
