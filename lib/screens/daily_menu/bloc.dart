import 'dart:async';

import 'package:behandam/base/errors.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';

class ListFoodBloc {
  ListFoodBloc() {
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _listFood = BehaviorSubject<ListFoodData?>();
  final _tags = BehaviorSubject<List<Tag>?>();
  final _foods = BehaviorSubject<List<ListFood>?>();
  final _loadingMoreFoods = BehaviorSubject<bool>();
  final _selectedTagIds = BehaviorSubject<List<int>?>();
  final _mealId = BehaviorSubject<int>();
  final _selectedFood = BehaviorSubject<ListFood?>();
  int _totalRow = 0;
  int _offset = 0;
  String? _search;
  ListFood? _previousFood;

  String get filter {
    final text;
    if (_selectedTagIds.valueOrNull == null)
      text =
          '{"page":{"offset":${_offset * 30},"limit":30},"sort":[{"field":"title","dir":"asc"}],"filters":[[{"field":"title","op":"like","value":"${_search ?? ""}"}],[{"field":"meal_id","op":"=","value":${_mealId.valueOrNull}}]]}';
    else {
      String tags = '';
      _selectedTagIds.value!.forEach((tagId) {
        tags += ',[{"field":"tag_id","op":"=","value":$tagId}]';
      });
      text =
          '{"page":{"offset":${_offset * 30},"limit":30},"sort":[{"field":"title","dir":"asc"}],"filters":[[{"field":"title","op":"like","value":"${_search ?? ""}"}],[{"field":"meal_id","op":"=","value":${_mealId.valueOrNull}}]$tags]}';
    }
    return text;
  }

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<ListFoodData?> get listFood => _listFood.stream;

  Stream<List<ListFood>?> get foods => _foods.stream;

  Stream<List<Tag>?> get tags => _tags.stream;

  Stream<bool> get loadingMoreFoods => _loadingMoreFoods.stream;

  bool get _isNotLoadingMore => _loadingMoreFoods.valueOrNull.isNullOrFalse;

  bool get _stillHaveMoreItems =>
      (_foods.valueOrNull?.length ?? 0) < _totalRow &&
      _listFood.valueOrNull?.items.foods?.length != 0;

  Stream<List<int>?> get selectedTagIds => _selectedTagIds.stream;

  Stream<int> get mealId => _mealId.stream;

  Stream<ListFood?> get selectedFood => _selectedFood.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _loadingMoreFoods.value = true;
    _repository.listFood(filter).then((value) {
      _listFood.value = value.requireData;
      if (_tags.valueOrNull == null) _tags.value = value.data?.items.tags;
      _totalRow = value.data?.count ?? 0;
      if (value.requireData.items.foods != null &&
          value.requireData.items.foods!.length > 0) {
        value.data?.items.foods.let((it) => _updateFoods(it!));
      }
      debugPrint('tags $_totalRow / ${_foods.value?.length}');
    }).whenComplete(() {
      _loadingMoreFoods.value = false;
      _loadingContent.value = false;
    });
  }

  void _updateFoods(List<ListFood> newList) {
    if (_offset == 0 && newList.isEmpty) {
      _foods.addError(NoResultFoundError());
      return;
    }
    final previousList = _foods.valueOrNull ?? [];
    _foods.value = [...previousList, ...newList];
  }

  // void onLoadContent() {
  //   _loadContent();
  // }

  void onScrollReachingEnd() {
    if (_isNotLoadingMore && _stillHaveMoreItems) {
      _offset++;
      _loadContent();
    }
  }

  void onTagChanged(int newTagId) {
    debugPrint('new tag $newTagId');
    if (_selectedTagIds.valueOrNull != null &&
        _selectedTagIds.value!.contains(newTagId)) {
      _selectedTagIds.value!.remove(newTagId);
      debugPrint('remove tag ${_selectedTagIds.valueOrNull}');
    } else {
      if (_selectedTagIds.valueOrNull == null) _selectedTagIds.value = [];
      _selectedTagIds.value!.add(newTagId);
      debugPrint('add tag ${_selectedTagIds.valueOrNull}');
    }
    debugPrint('new tag ${_selectedTagIds.valueOrNull}');
    _offset = 0;
    _foods.value = null;
    _loadContent();
  }

  void onMealChanged(int newMealId) {
    _mealId.value = newMealId;
    _offset = 0;
    _foods.value = null;
    _loadContent();
  }

  void onFoodChanged(ListFood newFood) {
    debugPrint('new list food ${newFood.toJson()}');
    if (_previousFood == null || _previousFood != newFood) {
      _selectedFood.value = newFood;
      _previousFood = newFood;
    } else {
      _previousFood = null;
      _selectedFood.value = null;
    }
  }

  void onSearchInputChanged(String newValue) {
    _search = newValue;
    _offset = 0;
    _foods.value = null;
    _loadContent();
  }

  void dispose() {
    _loadingContent.close();
    _tags.close();
    _listFood.close();
    _foods.close();
    _loadingMoreFoods.close();
    _selectedTagIds.close();
    _mealId.close();
    _selectedFood.close();
  }
}
