import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/filter/filter.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class ListFoodBloc {
  ListFoodBloc() {
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _listFood = BehaviorSubject<ListFoodData>();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<ListFoodData> get listFood => _listFood.stream;

  void _loadContent() {
    _loadingContent.value = true;
    // final sort = Sort(field: 'title', dir: 'asc');
    // final page = PageFilter(offset: 0, limit: 30);
    // final filter1 = Filter(field: 'meal_id', op: '=', value: '2');
    // final filter2 = Filter(field: 'title', op: 'like', value: '');
    final filter = '{"page":{"offset":0,"limit":30},"sort":[{"field":"title","dir":"asc"}],"filters":[[{"field":"title","op":"like","value":""}],[{"field":"meal_id","op":"=","value":1}]]}';
    Map<String, dynamic> _filter = {
      "page": {
        "offset": "0",
        "limit": "30",
      },
      "sort": [
        {
          "field": "title",
          "dir": "asc",
        }
      ],
      "filters": [
        [
          {"field": "title", "op": "like", "value": ""}
        ],
        [
          {"field": "meal_id", "op": "=", "value": "1"}
        ],
        // if (selectedTags != null && selectedTags.length > 0)
        //   ...selectedTags.map((element) {
        //     return [
        //       {'field': 'tag_id', 'op': '=', 'value': element}
        //     ];
        //   }).toList()
      ],
    };
    _repository.listFood(filter.toString()).then((value) {
      _listFood.value = value.data!;
      debugPrint('tags ');
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _listFood.close();
  }
}
