import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/obstructive_disease.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:velocity_x/velocity_x.dart';

class OtherSicknessBloc {
  OtherSicknessBloc() {
    _waiting.safeValue = false;
  }

  Repository _repository = Repository.getInstance();

  late String _path;
  List<int> userDiseaseIds = [];
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

  void updateSickness(int indexSickness, int indexCategory, ObstructiveDisease sickness) {
    List<ObstructiveDiseaseCategory> userSickness = _userSickness.value;
    userSickness[indexCategory].diseases![indexSickness] = sickness;
    _userSickness.safeValue = userSickness;
  }

  void getNotBlockingSickness() {
    _waiting.safeValue = true;
    _repository.getNotBlockingSickness().then((value) {
      userDiseaseIds = value.data!.userDiseaseIds!;
      value.data!.diseaseCategories!.forEach((diseaseCategory) {
        diseaseCategory.diseases!.forEach((disease) {
          // check in diseases id
          checkDiseaseSelected(userDiseaseIds, disease);
        });
        // check in diseases categories id
        checkDiseaseCategorySelected(userDiseaseIds, diseaseCategory);
      });

      _userSickness.safeValue = value.data!.diseaseCategories!;
    }).whenComplete(() => _waiting.safeValue = false);
  }

  void checkDiseaseSelected(List<int> userSelectedDiseaseArray, ObstructiveDisease disease) {
    userSelectedDiseaseArray.forEach((element) {
      if (disease.id == element) {
        disease.isSelected = true;
      }
    });
  }

  void checkDiseaseCategorySelected(
      List<int> userSelectedDiseaseArray, ObstructiveDiseaseCategory disease) {
    userSelectedDiseaseArray.forEach((element) {
      if (disease.id == element) {
        disease.isSelected = true;
      }
    });
  }

  void sendSickness() {
    _repository.sendSickness(_userSickness.value, userDiseaseIds).then((value) {
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
