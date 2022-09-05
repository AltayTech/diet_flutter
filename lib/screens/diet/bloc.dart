import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:rxdart/rxdart.dart';

class PhysicalInfoBloc {
  PhysicalInfoBloc() {}

  final _repository = Repository.getInstance();
  final _loadingContent = BehaviorSubject<bool>();
  final _physicalInfoData = BehaviorSubject<PhysicalInfoData>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();
  final _popLoadingDialog = LiveEvent();

  String? date;

  Stream<bool> get loadingContent => _loadingContent.stream;

  Stream<PhysicalInfoData> get physicalInfoData => _physicalInfoData.stream;
  PhysicalInfoData get physicalInfoValue => _physicalInfoData.value;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  Stream get popLoadingDialog => _popLoadingDialog.stream;

  late PhysicalInfoData _physicalInfo;

  void physicalInfo() {
    _physicalInfo = PhysicalInfoData();
    _physicalInfo.gender=GenderType.Female;
    _physicalInfoData.safeValue = _physicalInfo;

/*  _repository.physicalInfo().then((value) {
      _physicalInfoData = value.data!;
      debugPrint('repository ${_physicalInfoData}');
    }).whenComplete(() => null);*/
  }

  void sendRequest() {
    _repository.sendInfo(_physicalInfoData.value).then((value) {
      _navigateTo.fire(value.next);
    }).whenComplete(() => _popLoadingDialog.fire(false));
  }

  void setGender(GenderType gender) {
    _physicalInfo.gender = gender;
    _physicalInfoData.safeValue = _physicalInfo;
  }

  void dispose() {
    _loadingContent.close();

    _navigateTo.close();
    _showServerError.close();
  }
}
