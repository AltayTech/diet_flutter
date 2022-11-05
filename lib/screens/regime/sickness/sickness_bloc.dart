import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/obstructive_disease.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SicknessBloc {
  SicknessBloc() {
    _waiting.safeValue = false;
  }

  List<Map<String, dynamic>> _illColor = [
    {
      'barColor': Color.fromRGBO(230, 244, 254, 1),
      'bgColor': Color.fromRGBO(242, 249, 255, 1),
      'shadow': Color.fromRGBO(236, 243, 253, 1),
      'tick': Color.fromRGBO(162, 223, 254, 1),
    },
    {
      'barColor': Color.fromRGBO(255, 233, 233, 1),
      'bgColor': Color.fromRGBO(255, 248, 248, 1),
      'shadow': Color.fromRGBO(255, 241, 241, 1),
      'tick': Color.fromRGBO(255, 128, 128, 1),
    },
    {
      'barColor': Color.fromRGBO(245, 229, 255, 1),
      'bgColor': Color.fromRGBO(250, 245, 253, 1),
      'shadow': Color.fromRGBO(248, 241, 255, 1),
      'tick': Color.fromRGBO(187, 121, 255, 1),
    },
    {
      'barColor': Color.fromRGBO(255, 231, 216, 1),
      'bgColor': Color.fromRGBO(255, 247, 244, 1),
      'shadow': Color.fromRGBO(255, 245, 239, 1),
      'tick': Color.fromRGBO(255, 160, 114, 1),
    },
  ];
  Repository _repository = Repository.getInstance();

  late String _path;
  late List<ObstructiveDisease> _userDisease;
  late ObstructiveDisease diseaseIds;
  late UserSicknessSpecial _userSicknessSpecial;
  final _waiting = BehaviorSubject<bool>();

  /*final _userSickness = BehaviorSubject<UserSickness>();*/
  final _helpers = BehaviorSubject<List<Help>>();
  final _status = BehaviorSubject<BodyStatus>();
  final _userCategoryDisease = BehaviorSubject<List<ObstructiveDiseaseCategory>>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popDialog = LiveEvent();

  String get path => _path;

  Stream<List<ObstructiveDiseaseCategory>> get userCategoryDisease => _userCategoryDisease;

  UserSicknessSpecial? get userSicknessSpecial => _userSicknessSpecial;

  List<ObstructiveDisease> get userDiseaseSickness => _userDisease;

  List<ObstructiveDiseaseCategory> get userCategoryDiseaseValue => _userCategoryDisease.value;

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<Help>> get helpers => _helpers.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get popDialog => _popDialog.stream;

  void updateSickness(int index, ObstructiveDiseaseCategory category) {
    List<ObstructiveDiseaseCategory> categories = _userCategoryDisease.value;
    if (!category.isSelected!)
      category.diseases?.forEach((element) {
        element.isSelected = false;
      });
    categories[index] = category;
    _userCategoryDisease.safeValue = categories;
  }

  void getSickness() async {
    _waiting.safeValue = true;
    _repository.getBlockingSickness().then((value) {
      _userCategoryDisease.safeValue = value.data!.diseaseCategories!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void getSicknessSpecial() async {
    _waiting.safeValue = true;
    _repository.getSicknessSpecial().then((value) {
      _userSicknessSpecial = value.data!;
      int index = 0;
      if (value.data != null) {
        _userSicknessSpecial.specials?.forEach((sickness) {
          sickness.barColor = _illColor[index]['barColor'];
          sickness.bgColor = _illColor[index]['bgColor'];
          sickness.tick = _illColor[index]['tick'];
          sickness.shadow = _illColor[index]['shadow'];
          // print('Start sicknesses sick ${sickness.toJson()}');
          _userSicknessSpecial.userSpecials?.forEach((user) {
            //print('user sicknesses sick ${sickness.toJson()}');
            if (user.id == sickness.id) {
              sickness.isSelected = true;
            }
          });
          sickness.children?.forEach((child) {
            _userSicknessSpecial.userSpecials?.forEach((user) {
              if (user.id == child.id) {
                sickness.isSelected = true;
                child.isSelected = true;
              }
            });
          });
        });
        if (index == _illColor.length - 1)
          index = 0;
        else
          index += 1;
      }
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void sendSickness() {
    _repository.sendSickness(_userCategoryDisease.value, []).then((value) {
      _navigateTo.fireMessage('/${value.next}');
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _popDialog.fire(true);
    });
  }

  void sendSicknessSpecial() {
    _repository.sendSicknessSpecial(userSicknessSpecial!).then((value) {
      _navigateTo.fireMessage('/${value.next}');
    }).whenComplete(() {
      if (!MemoryApp.isNetworkAlertShown) _popDialog.fire(true);
    });
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _popDialog.close();
    _waiting.close();
    _status.close();
    _helpers.close();
    _userCategoryDisease.close();
  }
}
