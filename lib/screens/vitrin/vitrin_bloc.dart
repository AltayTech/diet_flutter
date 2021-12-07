import 'dart:async';

import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class VitrinBloc{
  VitrinBloc(){
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  String? _url;
  final _waiting = BehaviorSubject<bool>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();

  String? get url => _url;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;


  void checkFitamin() async {
      _repository.checkFitamin().then((value) {
        _url = value.data!.url;
        if(_url!.contains('fitamin://'))
          _navigateToVerify.fire(true);
        else
          _navigateToVerify.fire(false);
      });
  }


  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _waiting.close();
  }
}
