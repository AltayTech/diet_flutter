import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/status/visit_item.dart';
import 'package:rxdart/rxdart.dart';

class StatusBloc {
  StatusBloc() {
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  late List<Visit>? _visits;
  late VisitItem _visitItem;

  final _waiting = BehaviorSubject<bool>();
  final _showInformation = BehaviorSubject<bool>();

  String get path => _path;

  VisitItem? get visitItem => _visitItem;

  List<Visit> get visits => _visits ?? [];
  List<Visit> get visitsChart => _visits ?? [];

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get showInformation => _showInformation.stream;

  void getVisitUser() {
    _waiting.value = true;
    _repository.getVisits().then((value) {
      _visitItem = value.requireData;
      _visits = value.data?.visits;
      if(value.data!=null)
      _visitItem.setMaxMinWeight();
    }).catchError((onError) {
      print('onError = > $onError');
    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void dispose() {
    _showInformation.close();
    _waiting.close();
  }
}
