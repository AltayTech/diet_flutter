import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/sickness.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';
class OtherSicknessBloc {
  OtherSicknessBloc() {
    _waiting.safeValue = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  final _waiting = BehaviorSubject<bool>();

  /*final _userSickness = BehaviorSubject<UserSickness>();*/
  final _userSickness = BehaviorSubject<List<Sickness>>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  Stream<List<Sickness>> get userSickness => _userSickness.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void updateSickness(int indexSickness, int indexCategory, SicknessCategory sickness) {
    List<Sickness> userSickness = _userSickness.value;
    userSickness[indexSickness].categories![indexCategory] = sickness;
    _userSickness.safeValue = userSickness;
  }

  void getNotBlockingSickness() async {
    _waiting.safeValue = true;
    _repository.getNotBlockingSickness().then((value) {
      _userSickness.safeValue = value.data! as List<Sickness>;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void sendSickness() {
    /*_repository
        .sendSickness(_userSickness.value)
        .then((value) {
          _navigateTo.fireMessage('/${value.next}');
        })
        .catchError((e) => _showServerError.fire(e));*/
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
    _userSickness.close();
  }
}
