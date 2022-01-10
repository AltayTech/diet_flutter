import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/food_list/bloc.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:behandam/extensions/bool.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/string.dart';


class MenuSelectBloc {
  MenuSelectBloc() {
    _loadContent();
  }
  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _menuTypes = BehaviorSubject<List<MenuType>>();
  final _selectedMenu = BehaviorSubject<Menu?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<List<MenuType>> get menuTypes => _menuTypes.stream;

  Stream<Menu?> get selectedMenu => _selectedMenu.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void _loadContent() {
    _loadingContent.value = true;
    _repository.menuType().then((value) {
      value.data?.items.let((it) {
        _menuTypes.value = it.map((e) => e).toList();
      });
      debugPrint('repository ${_menuTypes.value.length}');
    }).whenComplete(() => _loadingContent.value = false);
  }
  
  void onItemClick(Menu menu){
    _loadingContent.value = true;
    _selectedMenu.value = menu;
    ConditionRequestData requestData = ConditionRequestData();
    requestData.isPreparedMenu = true;
    requestData.menuId = menu.id;
    if(!navigator.currentConfiguration!.path.contains(Routes.listMenuSelect)) {
      _repository.setCondition(requestData).then((value) {
        debugPrint('condition menu ${value.next}');
        _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.value = false);
    }else {
      _repository.menuSelect(requestData).then((value) {
        _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.value = false);
    }
  }

  void term(){
    _loadingContent.value = true;
    _repository.term().then((value) {
      debugPrint('condition menu ${value.next}');
      debugPrint("path:${value.next}");
      _navigateTo.fire(value.next);
    }).whenComplete(() => _loadingContent.value = false);
  }

  void dispose() {
    _loadingContent.close();
    _menuTypes.close();
    _navigateTo.close();
    _showServerError.close();
    _selectedMenu.close();
  }
}
