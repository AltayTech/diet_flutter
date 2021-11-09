// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FilterRequestData _$FilterRequestDataFromJson(Map<String, dynamic> json) =>
    FilterRequestData(
      PageFilter.fromJson(json['page'] as Map<String, dynamic>),
      (json['sort'] as List<dynamic>)
          .map((e) => Sort.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['filters'] as List<dynamic>)
          .map((e) => (e as List<dynamic>)
              .map((e) => Filter.fromJson(e as Map<String, dynamic>))
              .toList())
          .toList(),
    );

Map<String, dynamic> _$FilterRequestDataToJson(FilterRequestData instance) =>
    <String, dynamic>{
      'page': instance.page,
      'sort': instance.sort,
      'filters': instance.filters,
    };

PageFilter _$PageFilterFromJson(Map<String, dynamic> json) => PageFilter(
      offset: json['offset'] as int? ?? 0,
      limit: json['limit'] as int? ?? 30,
    );

Map<String, dynamic> _$PageFilterToJson(PageFilter instance) =>
    <String, dynamic>{
      'offset': instance.offset,
      'limit': instance.limit,
    };

Sort _$SortFromJson(Map<String, dynamic> json) => Sort(
      field: json['field'] as String? ?? 'title',
      dir: json['dir'] as String? ?? 'asc',
    );

Map<String, dynamic> _$SortToJson(Sort instance) => <String, dynamic>{
      'field': instance.field,
      'dir': instance.dir,
    };

Filter _$FilterFromJson(Map<String, dynamic> json) => Filter(
      field: json['field'] as String? ?? 'title',
      op: json['op'] as String? ?? 'like',
      value: json['value'] as String? ?? '',
    );

Map<String, dynamic> _$FilterToJson(Filter instance) => <String, dynamic>{
      'field': instance.field,
      'op': instance.op,
      'value': instance.value,
    };
