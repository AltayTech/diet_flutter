import 'package:json_annotation/json_annotation.dart';
part 'filter.g.dart';

@JsonSerializable()
class FilterRequestData {
  FilterRequestData(
      this.page,
      this.sort,
      this.filters,
      );

  @JsonKey(name: 'page')
  final PageFilter page;

  @JsonKey(name: 'sort')
  final List<Sort> sort;

  @JsonKey(name: 'filters')
  final List<List<Filter>> filters;

  factory FilterRequestData.fromJson(Map<String, dynamic> json) =>
      _$FilterRequestDataFromJson(json);

  Map<String, dynamic> toJson() => _$FilterRequestDataToJson(this);
}

@JsonSerializable()
class PageFilter {
  PageFilter({
    required this.offset,
    required this.limit,
});

  @JsonKey(name: 'offset', defaultValue: 0)
  final int offset;

  @JsonKey(name: 'limit', defaultValue: 30)
  final int limit;

  factory PageFilter.fromJson(Map<String, dynamic> json) =>
      _$PageFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PageFilterToJson(this);
}

@JsonSerializable()
class Sort {
  Sort({
    required this.field,
    required this.dir,
});

  @JsonKey(name: 'field', defaultValue: 'title')
  final String field;

  @JsonKey(name: 'dir', defaultValue: 'asc')
  final String dir;

  factory Sort.fromJson(Map<String, dynamic> json) =>
      _$SortFromJson(json);

  Map<String, dynamic> toJson() => _$SortToJson(this);
}

@JsonSerializable()
class Filter {
  Filter({
    required this.field,
    required this.op,
    required this.value,
});

  @JsonKey(name: 'field', defaultValue: 'title')
  final String field;

  @JsonKey(name: 'op', defaultValue: 'like')
  final String op;

  @JsonKey(name: 'value', defaultValue: '')
  final String value;

  factory Filter.fromJson(Map<String, dynamic> json) =>
      _$FilterFromJson(json);

  Map<String, dynamic> toJson() => _$FilterToJson(this);
}