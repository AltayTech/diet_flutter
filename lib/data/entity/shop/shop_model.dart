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
enum TypeMediaShop { lock, progress, downloadAndPlay, play }

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
  @JsonKey(name: "category_name_en")
  String? categoryNameEn;
  @JsonKey(name: "category_name_hin")
  String? category_name;
  @JsonKey(name: "category_icon")
  String? category_icon;
  @JsonKey(name: "image")
  String? image;
  @JsonKey(name: "products")
  List<ShopProduct>? products;

  @JsonKey(name: "items")
  List<ShopProduct>? items;

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
  @JsonKey(name: "product_name")
  String? productName;
  @JsonKey(name: "product_thambnail")
  String? productThambnail;
  @JsonKey(name: "short_descp_en")
  String? shortDescriptionEn;
  @JsonKey(name: "short_description")
  String? shortDescription;
  @JsonKey(name: "long_description")
  String? longDescription;
  @JsonKey(name: "selling_price")
  dynamic sellingPrice;
  @JsonKey(name: "discount_price")
  dynamic discountPrice;
  @JsonKey(name: "action")
  String? action;
  @JsonKey(name: "action_type")
  ActionType? action_type;
  @JsonKey(name: "user_order_date")
  String? userOrderDate;
  @JsonKey(name: "lessons")
  List<Lessons>? lessons;

  ShopProduct();

  String? get discount  => (int.parse(sellingPrice.toString()) - int.parse(discountPrice.toString())).toString();

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
class Lessons {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "product_id")
  int? productId;
  @JsonKey(name: "lesson_name")
  String? lessonName;
  @JsonKey(name: "is_active")
  int? isActive;
  @JsonKey(name: "is_free", defaultValue: 0)
  late int isFree;
  @JsonKey(name: "order")
  int? order;
  @JsonKey(name: "score")
  int? score;
  @JsonKey(name: "minutes")
  int? minutes;
  @JsonKey(name: "views")
  int? views;
  @JsonKey(name: "downloads")
  int? downloads;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "updated_at")
  String? updatedAt;
  @JsonKey(name: "video")
  String? video;
  @JsonKey(name: "path")
  String? path;

  TypeMediaShop? typeMediaShop;

  Lessons();

  factory Lessons.fromJson(Map<String, dynamic> json) => _$LessonsFromJson(json);

  Map<String, dynamic> toJson() => _$LessonsToJson(this);
}

@JsonSerializable()
class ProductMedia {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "file_name")
  String? fileName;
  @JsonKey(name: "size")
  int? size;
  @JsonKey(name: "created_at")
  String? createdAt;
  @JsonKey(name: "updated_at")
  String? updatedAt;

  ProductMedia();

  factory ProductMedia.fromJson(Map<String, dynamic> json) => _$ProductMediaFromJson(json);

  Map<String, dynamic> toJson() => _$ProductMediaToJson(this);
}
