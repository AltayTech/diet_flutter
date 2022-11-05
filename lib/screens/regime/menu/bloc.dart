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
  }

  Repository _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _menuTypes = BehaviorSubject<List<MenuType>>();
  final _selectedMenu = BehaviorSubject<Menu?>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popDialog = LiveEvent();

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<List<MenuType>> get menuTypes => _menuTypes.stream;

  Stream<Menu?> get selectedMenu => _selectedMenu.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get popDialog => _popDialog.stream;

  void loadContent() {
    _loadingContent.safeValue = true;
    _repository.menuType().then((value) {
      value.data?.items.let((it) {
        _menuTypes.value = it.map((e) => e).toList();
      });
      debugPrint('repository ${_menuTypes.value.length}');
    }).whenComplete(() => _loadingContent.safeValue = false);
  }

  void menuSelected(Menu menu) {
    _selectedMenu.value = menu;
  }

  void onItemClick() {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.isPreparedMenu = true;
    requestData.menuId = _selectedMenu.value!.id;
    if (!navigator.currentConfiguration!.path.contains(Routes.listMenuSelect)) {
      _repository.setCondition(requestData).then((value) {
        debugPrint('condition menu ${value.next}');
        _navigateTo.fire({'next': value.next, 'params': _selectedMenu.value});
      }).whenComplete(() => _popDialog.fire(true));
    } else {
      _repository.menuSelect(requestData).then((value) {
        _navigateTo.fire({'next': value.next, 'params': _selectedMenu.value});
      }).whenComplete(() => _popDialog.fire(true));
    }
  }

  void term() {
    _repository.term().then((value) {
      debugPrint('condition menu ${value.next}');
      debugPrint("path:${value.next}");
      _navigateTo.fire(value.next);
    }).whenComplete(() => _popDialog.fire(true));
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _loadingContent.close();
    _menuTypes.close();
    _navigateTo.close();
    _popDialog.close();
    _selectedMenu.close();
  }
}
