import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/obstructive_disease.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class OtherSicknessBloc {
  OtherSicknessBloc() {
    _waiting.safeValue = false;
  }

  Repository _repository = Repository.getInstance();

  late String _path;
  late UserSickness userSicknessSelectedId;
  final _waiting = BehaviorSubject<bool>();

  /*final _userSickness = BehaviorSubject<UserSickness>();*/
  final _userSickness = BehaviorSubject<List<ObstructiveDiseaseCategory>>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  Stream<List<ObstructiveDiseaseCategory>> get userSickness => _userSickness.stream;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void updateSickness(int indexSickness, int indexCategory,
      ObstructiveDisease sickness) {
    List<ObstructiveDiseaseCategory> userSickness = _userSickness.value;
    userSickness[indexCategory].diseases![indexSickness] = sickness;
    _userSickness.safeValue = userSickness;
  }

  void getNotBlockingSickness() {
    _waiting.safeValue = true;
    _repository.getNotBlockingSickness().then((value) {
      _userSickness.safeValue = value.data!.diseaseCategories!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void sendSickness() {
    _repository.sendSickness(_userSickness.value).then((value) {
      _navigateTo.fireMessage('/${value.next}');
    }).catchError((e) => _showServerError.fire(e));
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
    _userSickness.close();
  }
}
