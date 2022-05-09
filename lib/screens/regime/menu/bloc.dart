import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/routes.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/object.dart';
import 'package:behandam/extensions/stream.dart';

class MenuSelectBloc {
  MenuSelectBloc() {
    loadContent();
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

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.menuType().then((value) {
      value.data?.items.let((it) {
        _menuTypes.value = it.map((e) => e).toList();
      });
      debugPrint('repository ${_menuTypes.value.length}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void menuSelected(Menu menu){
    _selectedMenu.value = menu;
  }

  void onItemClick(){
    _loadingContent.safeValue = true;
    ConditionRequestData requestData = ConditionRequestData();
    requestData.isPreparedMenu = true;
    requestData.menuId = _selectedMenu.value!.id;
    if(!navigator.currentConfiguration!.path.contains(Routes.listMenuSelect)) {
      _repository.setCondition(requestData).then((value) {
        debugPrint('condition menu ${value.next}');
        _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.safeValue = false);
    }else {
      _repository.menuSelect(requestData).then((value) {
        _navigateTo.fire(value.next);
      }).whenComplete(() => _loadingContent.safeValue = false);
    }
  }

  void term(){
    _loadingContent.safeValue = true;
    _repository.term().then((value) {
      debugPrint('condition menu ${value.next}');
      debugPrint("path:${value.next}");
      _navigateTo.fire(value.next);
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void dispose() {
    _loadingContent.close();
    _menuTypes.close();
    _navigateTo.close();
    _showServerError.close();
    _selectedMenu.close();
  }
}
