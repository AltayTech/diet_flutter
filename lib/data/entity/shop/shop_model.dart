import 'package:json_annotation/json_annotation.dart';

part 'shop_model.g.dart';

enum StyleType {
  @JsonValue('slider')
  slider,
  @JsonValue('user_action')
  userAction,
  @JsonValue('product_category')
  productCategory,
  @JsonValue('banner')
  banner,
}
enum ActionType {
  @JsonValue('link')
  link,
  @JsonValue('deep_link')
  deepLink,
}

@JsonSerializable()
class ShopModel {
  @JsonKey(name: "items")
  List<ShopItem>? items;

  ShopModel();

  factory ShopModel.fromJson(Map<String, dynamic> json) => _$ShopModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShopModelToJson(this);
}

@JsonSerializable()
class ShopItem {
  @JsonKey(name: "style_type")
  StyleType? styleType;

  @JsonKey(name: "items")
  List<BannerItem>? items;

  @JsonKey(name: "banner")
  BannerItem? banner;


  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "action_type")
  ActionType? action_type;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "icon")
  String? icon;
  @JsonKey(name: "icon_url")
  String? icon_url;
  @JsonKey(name: "category")
  ShopCategory? category;

  ShopItem();

  factory ShopItem.fromJson(Map<String, dynamic> json) => _$ShopItemFromJson(json);

  Map<String, dynamic> toJson() => _$ShopItemToJson(this);
}

@JsonSerializable()
class ShopCategory {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "products")
  List<ShopProduct>? products;

  @JsonKey(name: "category_name_en")
  String? categoryNameEn;
  @JsonKey(name: "category_name_hin")
  String? category_name;
  @JsonKey(name: "category_icon")
  String? category_icon;

  ShopCategory();

  factory ShopCategory.fromJson(Map<String, dynamic> json) => _$ShopCategoryFromJson(json);

  Map<String, dynamic> toJson() => _$ShopCategoryToJson(this);
}

@JsonSerializable()
class ShopProduct {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "items")
  List<ShopProduct>? items;
  @JsonKey(name: "category_id")
  int? categoryId;
  @JsonKey(name: "product_name_en")
  String? productNameEn;
  @JsonKey(name: "product_name_hin")
  String? productNameHin;
  @JsonKey(name: "product_thambnail")
  String? productThambnail;
  @JsonKey(name: "short_descp_en")
  String? shortDescriptionEn;
  @JsonKey(name: "short_descp_hin")
  String? shortDescription;
  @JsonKey(name: "long_descp_en")
  String? longDescriptionEn;
  @JsonKey(name: "long_descp_hin")
  String? longDescription;
  @JsonKey(name: "selling_price")
  int? sellingPrice;
  @JsonKey(name: "discount_price")
  int? discountPrice;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "action_type")
  ActionType? action_type;

  ShopProduct();

  factory ShopProduct.fromJson(Map<String, dynamic> json) => _$ShopProductFromJson(json);

  Map<String, dynamic> toJson() => _$ShopProductToJson(this);
}

@JsonSerializable()
class BannerItem {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "slider_img")
  String? sliderImg;
  @JsonKey(name: "title")
  String? title;
  @JsonKey(name: "description")
  String? description;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "action_type")
  ActionType? action_type;
  BannerItem();

  factory BannerItem.fromJson(Map<String, dynamic> json) => _$BannerItemFromJson(json);

  Map<String, dynamic> toJson() => _$BannerItemToJson(this);
}

@JsonSerializable()
class Orders {
  @JsonKey(name: "items")
  List<ShopProduct>? items;
  @JsonKey(name: "count")
  int? count;
  @JsonKey(name: "sum")
  int? sum;

  Orders();

  factory Orders.fromJson(Map<String, dynamic> json) => _$OrdersFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "category_name_en")
  int? categoryNameEn;
  @JsonKey(name: "category_name_hin")
  String? categoryNameHin;
  @JsonKey(name: "image")
  String? image;

  Category();

  factory Category.fromJson(Map<String, dynamic> json) => _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}
