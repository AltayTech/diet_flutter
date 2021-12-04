// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShopModel _$ShopModelFromJson(Map<String, dynamic> json) => ShopModel()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ShopItem.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ShopModelToJson(ShopModel instance) => <String, dynamic>{
      'items': instance.items,
    };

ShopItem _$ShopItemFromJson(Map<String, dynamic> json) => ShopItem()
  ..styleType = $enumDecodeNullable(_$StyleTypeEnumMap, json['style_type'])
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
      .toList()
  ..banner = json['banner'] == null
      ? null
      : BannerItem.fromJson(json['banner'] as Map<String, dynamic>)
  ..title = json['title'] as String?
  ..action_type = $enumDecodeNullable(_$ActionTypeEnumMap, json['action_type'])
  ..action = json['action'] as String?
  ..icon = json['icon'] as String?
  ..icon_url = json['icon_url'] as String?
  ..category = json['category'] == null
      ? null
      : ShopCategory.fromJson(json['category'] as Map<String, dynamic>);

Map<String, dynamic> _$ShopItemToJson(ShopItem instance) => <String, dynamic>{
      'style_type': _$StyleTypeEnumMap[instance.styleType],
      'items': instance.items,
      'banner': instance.banner,
      'title': instance.title,
      'action_type': _$ActionTypeEnumMap[instance.action_type],
      'action': instance.action,
      'icon': instance.icon,
      'icon_url': instance.icon_url,
      'category': instance.category,
    };

const _$StyleTypeEnumMap = {
  StyleType.slider: 'slider',
  StyleType.userAction: 'user_action',
  StyleType.productCategory: 'product_category',
  StyleType.banner: 'banner',
};

const _$ActionTypeEnumMap = {
  ActionType.link: 'link',
  ActionType.deepLink: 'deep_link',
};

ShopCategory _$ShopCategoryFromJson(Map<String, dynamic> json) => ShopCategory()
  ..id = json['id'] as int?
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..categoryNameEn = json['category_name_en'] as String?
  ..category_name = json['category_name_hin'] as String?
  ..category_icon = json['category_icon'] as String?;

Map<String, dynamic> _$ShopCategoryToJson(ShopCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'products': instance.products,
      'category_name_en': instance.categoryNameEn,
      'category_name_hin': instance.category_name,
      'category_icon': instance.category_icon,
    };

ShopProduct _$ShopProductFromJson(Map<String, dynamic> json) => ShopProduct()
  ..id = json['id'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..categoryId = json['category_id'] as int?
  ..productNameEn = json['product_name_en'] as String?
  ..productName = json['product_name_hin'] as String?
  ..productThambnail = json['product_thambnail'] as String?
  ..shortDescriptionEn = json['short_descp_en'] as String?
  ..shortDescription = json['short_descp_hin'] as String?
  ..longDescriptionEn = json['long_descp_en'] as String?
  ..longDescription = json['long_descp_hin'] as String?
  ..sellingPrice = json['selling_price'] as int?
  ..discountPrice = json['discount_price'] as int?
  ..action = json['action'] as String?
  ..action_type = $enumDecodeNullable(_$ActionTypeEnumMap, json['action_type']);

Map<String, dynamic> _$ShopProductToJson(ShopProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'category_id': instance.categoryId,
      'product_name_en': instance.productNameEn,
      'product_name_hin': instance.productName,
      'product_thambnail': instance.productThambnail,
      'short_descp_en': instance.shortDescriptionEn,
      'short_descp_hin': instance.shortDescription,
      'long_descp_en': instance.longDescriptionEn,
      'long_descp_hin': instance.longDescription,
      'selling_price': instance.sellingPrice,
      'discount_price': instance.discountPrice,
      'action': instance.action,
      'action_type': _$ActionTypeEnumMap[instance.action_type],
    };

BannerItem _$BannerItemFromJson(Map<String, dynamic> json) => BannerItem()
  ..id = json['id'] as int?
  ..sliderImg = json['slider_img'] as String?
  ..title = json['title'] as String?
  ..description = json['description'] as String?
  ..action = json['action'] as String?
  ..action_type = $enumDecodeNullable(_$ActionTypeEnumMap, json['action_type']);

Map<String, dynamic> _$BannerItemToJson(BannerItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'slider_img': instance.sliderImg,
      'title': instance.title,
      'description': instance.description,
      'action': instance.action,
      'action_type': _$ActionTypeEnumMap[instance.action_type],
    };

Orders _$OrdersFromJson(Map<String, dynamic> json) => Orders()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..count = json['count'] as int?
  ..sum = json['sum'] as int?;

Map<String, dynamic> _$OrdersToJson(Orders instance) => <String, dynamic>{
      'items': instance.items,
      'count': instance.count,
      'sum': instance.sum,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category()
  ..id = json['id'] as int?
  ..categoryNameEn = json['category_name_en'] as int?
  ..categoryNameHin = json['category_name_hin'] as String?
  ..image = json['image'] as String?;

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'category_name_en': instance.categoryNameEn,
      'category_name_hin': instance.categoryNameHin,
      'image': instance.image,
    };
