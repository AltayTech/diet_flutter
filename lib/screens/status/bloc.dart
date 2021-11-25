import 'dart:async';

import 'package:behandam/base/repository.dart';
import 'package:rxdart/rxdart.dart';

class StatusBloc {
  StatusBloc() {
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  late String _path;

  final _waiting = BehaviorSubject<bool>();
  final _showInformation = BehaviorSubject<bool>();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream<bool> get showInformation => _showInformation.stream;

  void getVisitUser() {
    _waiting.value = true;
    _repository.getVisits().then((value) {

    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void dispose() {
    _showInformation.close();
    _waiting.close();
  }
}
