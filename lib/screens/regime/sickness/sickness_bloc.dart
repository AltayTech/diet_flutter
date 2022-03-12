import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SicknessBloc {
  SicknessBloc() {
    _waiting.value = false;
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
  final _repository = Repository.getInstance();

  late String _path;
  late UserSickness _userSickness;
  late UserSicknessSpecial _userSicknessSpecial;
  final _waiting = BehaviorSubject<bool>();

  /*final _userSickness = BehaviorSubject<UserSickness>();*/
  final _helpers = BehaviorSubject<List<Help>>();
  final _status = BehaviorSubject<BodyStatus>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  UserSickness? get userSickness => _userSickness;

  UserSicknessSpecial? get userSicknessSpecial => _userSicknessSpecial;

  Stream<BodyStatus> get status => _status.stream;

  Stream<List<Help>> get helpers => _helpers.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void getSickness() async {
    _waiting.value = true;
    _repository.getSickness().then((value) {
      _userSickness = value.data!;
      int index = 0;
      if (value.data != null) {
        _userSickness.sickness_categories?.forEach((element) {
          element.barColor = _illColor[index]['barColor'];
          element.bgColor = _illColor[index]['bgColor'];
          element.tick = _illColor[index]['tick'];
          element.shadow = _illColor[index]['shadow'];
          element.sicknesses!.sort((a, b) {
            return a.order!.compareTo(b.order!);
          });
          element.sicknesses?.forEach((sickness) {
            // print('Start sicknesses sick ${sickness.toJson()}');
            _userSickness.userSicknesses?.forEach((user) {
              //print('user sicknesses sick ${sickness.toJson()}');
              if (user.id == sickness.id) {
                sickness.isSelected = true;
              }
            });
            sickness.children?.forEach((child) {
              _userSickness.userSicknesses?.forEach((user) {
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
        });
      }
    }).whenComplete(() => _waiting.value = false);
  }

  void getSicknessSpecial() async {
    _waiting.value = true;
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
    }).whenComplete(() => _waiting.value = false);
  }

  void sendSickness() {
    _waiting.value = true;
    _repository
        .sendSickness(userSickness!)
        .then((value) {
          _navigateTo.fireMessage('/${value.next}');
        })
        .catchError((e) => _showServerError.fire(e))
        .whenComplete(() {_waiting.value = false;});
  }

  void sendSicknessSpecial() {
    _repository.sendSicknessSpecial(userSicknessSpecial!).then((value) {
      _navigateTo.fireMessage('/${value.next}');
    }).whenComplete(() {
      _showServerError.fire(false);
    });
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
  }
}
