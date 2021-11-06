import 'dart:async';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:rxdart/rxdart.dart';

import '../../base/live_event.dart';
import '../../base/repository.dart';


class RegimeBloc{
  RegimeBloc(){
    _waiting.value = false;
    regimeTypeMethod();
  }

  final _repository = Repository.getInstance();

  // late RegimeType _type;
  final _waiting = BehaviorSubject<bool>();
  final _itemsList = BehaviorSubject<List<RegimeType>>();
  final _helpers = BehaviorSubject<List<Help>>();
  final _navigateToVerify = LiveEvent();
  final _showServerError = LiveEvent();
  // RegimeType get type => _type;
  Stream<List<RegimeType>> get itemList => _itemsList.stream;
  Stream<List<Help>> get helpers => _helpers.stream;
  Stream<bool> get waiting => _waiting.stream;
  Stream get navigateToVerify => _navigateToVerify.stream;
  Stream get showServerError => _showServerError.stream;


  // void fetchCountries() async {
  //  if(MemoryApp.countryCode == null)
  //   _repository.country().then((value) {
  //     MemoryApp.countryCode = value.data!;
  //     _subjectList.value = value.data!;
  //     value.data!.forEach((element){
  //       if(element.code == "98") {
  //         _subject = element;
  //       }
  //     });
  //   });
  // }

  void regimeTypeMethod() async {
    _waiting.value = true;
    _repository.regimeType().then((value) {
      _itemsList.value = value.data!.items!;
    }).whenComplete(() => _waiting.value = false);
  }

  void helpMethod() async {
    _waiting.value = true;
    _repository.helpDietType().then((value) {
      _helpers.value = value.data!.helpers!;
    }).whenComplete(() => _waiting.value = false);
  }

  void dispose() {
    _showServerError.close();
    _navigateToVerify.close();
    _itemsList.close();
    _waiting.close();
  }
}
