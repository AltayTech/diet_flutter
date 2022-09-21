import 'package:behandam/base/utils.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'package_list.g.dart';

@JsonSerializable()
class Package {
  @JsonKey(name: "items")
  List<Package>? items;

  @JsonKey(name: "services")
  List<ServicePackage>? servicesPackages;

  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "price")
  PackagePriceNew? price;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "media")
  String? media;

  @JsonKey(name: "description")
  String? description;

  @JsonKey(name: "package_id")
  int? package_id;

  @JsonKey(name: "refund_deadline", defaultValue: 0)
  int? refundDeadline;

  @JsonKey(name: "payment_type_id")
  int? type;

  @JsonKey(name: "is_suggestion",defaultValue: false)
  bool? is_suggestion;

  int? index;

  int? totalPrice;

  @JsonKey(name: "isSelected", defaultValue: false)
  bool? isSelected;

  Package();

  Color get barColor => Utils.getColorPackage(index!);

  Color get priceColor => Utils.getColorPackagePrice(index!);

  factory Package.fromJson(Map<String, dynamic> json) => _$PackageFromJson(json);

  Map<String, dynamic> toJson() => _$PackageToJson(this);
}

@JsonSerializable()
class PackageItem {
  @JsonKey(name: "items")
  List<PackageItem>? items;

  @JsonKey(name: "services")
  List<ServicePackage>? services;

  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "price")
  PackagePrice? price;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "media")
  String? media;

  @JsonKey(name: "package_id")
  int? package_id;

  @JsonKey(name: "refund_deadline", defaultValue: 0)
  int? refundDeadline;

  int? index;

  PackageItem();

  Color get barColor => Utils.getColorPackage(index!);

  Color get priceColor => Utils.getColorPackagePrice(index!);

  factory PackageItem.fromJson(Map<String, dynamic> json) => _$PackageItemFromJson(json);

  Map<String, dynamic> toJson() => _$PackageItemToJson(this);
}

@JsonSerializable()
class PackagePrice {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "priceable_id")
  int? priceableId;
  @JsonKey(name: "amount")
  int? amount;
  @JsonKey(name: "sale_amount")
  int? saleAmount;
  @JsonKey(name: "type")
  int? type;

  int? totalPrice;

  int get priceDiscount => ((amount ?? 0) - (saleAmount ?? 0));

  PackagePrice();

  factory PackagePrice.fromJson(Map<String, dynamic> json) => _$PackagePriceFromJson(json);

  Map<String, dynamic> toJson() => _$PackagePriceToJson(this);
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
  @JsonKey(name: "total_price")
  int? totalPrice;

  @JsonKey(name: "product_id")
  int? product_id;

  @JsonKey(name: "package_id")
  int? packageId;

  @JsonKey(name: "discount_message")
  String? discount_message;

  @JsonKey(name: "description")
  String? description;

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

  @JsonKey(name: "price")
  PackagePriceNew? price;

  @JsonKey(name: "isSelected", defaultValue: false)
  bool? isSelected;

  ServicePackage();

  factory ServicePackage.fromJson(Map<String, dynamic> json) => _$ServicePackageFromJson(json);

  Map<String, dynamic> toJson() => _$ServicePackageToJson(this);
}

@JsonSerializable()
class PackagePriceNew {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "priceable_id")
  int? priceableId;
  @JsonKey(name: "amount",defaultValue: 0)
  int? price;
  @JsonKey(name: "sale_amount")
  int? finalPrice;
  @JsonKey(name: "type")
  int? type;

  int? totalPrice;

  int get priceDiscount => ((price ?? 0) - (finalPrice ?? 0));

  PackagePriceNew();

  factory PackagePriceNew.fromJson(Map<String, dynamic> json) => _$PackagePriceNewFromJson(json);

  Map<String, dynamic> toJson() => _$PackagePriceNewToJson(this);
}
