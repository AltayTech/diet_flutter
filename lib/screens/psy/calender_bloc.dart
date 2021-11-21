import 'dart:async';
import 'package:behandam/data/entity/regime/body_state.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class RegimeBloc{
  RegimeBloc(){
    _waiting.value = false;
    calenderMethod();
  }

  final _repository = Repository.getInstance();

  late String _path;
  late String _name;
  final _waiting = BehaviorSubject<bool>();
  final _itemsList = BehaviorSubject<List<RegimeType>>();
  final _helpers = BehaviorSubject<List<Help>>();
  final _status = BehaviorSubject<BodyStatus>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;
  String get name => _name;
  Stream<BodyStatus> get status => _status.stream;
  Stream<List<RegimeType>> get itemList => _itemsList.stream;
  Stream<List<Help>> get helpers => _helpers.stream;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;

  void calenderMethod() async {
    _waiting.value = true;
    _repository.regimeType().then((value) {
      _itemsList.value = value.data!.items!;
    }).whenComplete(() => _waiting.value = false);
  }


  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _itemsList.close();
    _waiting.close();
  }
}
