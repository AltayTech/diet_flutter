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
  ..categoryNameEn = json['category_name_en'] as String?
  ..category_name = json['category_name_hin'] as String?
  ..category_icon = json['category_icon'] as String?
  ..image = json['image'] as String?
  ..products = (json['products'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ShopCategoryToJson(ShopCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'category_name_en': instance.categoryNameEn,
      'category_name_hin': instance.category_name,
      'category_icon': instance.category_icon,
      'image': instance.image,
      'products': instance.products,
      'items': instance.items,
    };

ShopProduct _$ShopProductFromJson(Map<String, dynamic> json) => ShopProduct()
  ..id = json['id'] as int?
  ..items = (json['items'] as List<dynamic>?)
      ?.map((e) => ShopProduct.fromJson(e as Map<String, dynamic>))
      .toList()
  ..categoryId = json['category_id'] as int?
  ..productName = json['product_name'] as String?
  ..productThambnail = json['product_thambnail'] as String?
  ..shortDescriptionEn = json['short_descp_en'] as String?
  ..shortDescription = json['short_description'] as String?
  ..longDescription = json['long_description'] as String?
  ..sellingPrice = json['selling_price']
  ..discountPrice = json['discount_price']
  ..action = json['action'] as String?
  ..action_type = $enumDecodeNullable(_$ActionTypeEnumMap, json['action_type'])
  ..userOrderDate = json['user_order_date'] as String?
  ..lessons = (json['lessons'] as List<dynamic>?)
      ?.map((e) => Lessons.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$ShopProductToJson(ShopProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'category_id': instance.categoryId,
      'product_name': instance.productName,
      'product_thambnail': instance.productThambnail,
      'short_descp_en': instance.shortDescriptionEn,
      'short_description': instance.shortDescription,
      'long_description': instance.longDescription,
      'selling_price': instance.sellingPrice,
      'discount_price': instance.discountPrice,
      'action': instance.action,
      'action_type': _$ActionTypeEnumMap[instance.action_type],
      'user_order_date': instance.userOrderDate,
      'lessons': instance.lessons,
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

Lessons _$LessonsFromJson(Map<String, dynamic> json) => Lessons()
  ..id = json['id'] as int?
  ..productId = json['product_id'] as int?
  ..lessonName = json['lesson_name'] as String?
  ..isActive = json['is_active'] as int?
  ..isFree = json['is_free'] as int? ?? 0
  ..order = json['order'] as int?
  ..score = json['score'] as int?
  ..minutes = json['minutes'] as int?
  ..views = json['views'] as int?
  ..downloads = json['downloads'] as int?
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?
  ..video = json['video'] as String?
  ..path = json['path'] as String?
  ..typeMediaShop =
      $enumDecodeNullable(_$TypeMediaShopEnumMap, json['typeMediaShop']);

Map<String, dynamic> _$LessonsToJson(Lessons instance) => <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'lesson_name': instance.lessonName,
      'is_active': instance.isActive,
      'is_free': instance.isFree,
      'order': instance.order,
      'score': instance.score,
      'minutes': instance.minutes,
      'views': instance.views,
      'downloads': instance.downloads,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'video': instance.video,
      'path': instance.path,
      'typeMediaShop': _$TypeMediaShopEnumMap[instance.typeMediaShop],
    };

const _$TypeMediaShopEnumMap = {
  TypeMediaShop.lock: 'lock',
  TypeMediaShop.progress: 'progress',
  TypeMediaShop.downloadAndPlay: 'downloadAndPlay',
  TypeMediaShop.play: 'play',
};

ProductMedia _$ProductMediaFromJson(Map<String, dynamic> json) => ProductMedia()
  ..id = json['id'] as int?
  ..name = json['name'] as String?
  ..fileName = json['file_name'] as String?
  ..size = json['size'] as int?
  ..createdAt = json['created_at'] as String?
  ..updatedAt = json['updated_at'] as String?;

Map<String, dynamic> _$ProductMediaToJson(ProductMedia instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'file_name': instance.fileName,
      'size': instance.size,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
