import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:rxdart/rxdart.dart';
import 'package:behandam/extensions/stream.dart';

class PackageBloc {
  PackageBloc() {

  }

  Repository _repository = Repository.getInstance();

  late String _path;
  List<PackageItem>? _list;
  late PackageItem _packageSelected;

  final _waiting = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  List<PackageItem>? get list => _list;

  PackageItem get package => _packageSelected;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void getPackage() {
    _waiting.safeValue = true;
    _repository.getPackagesList().then((value) {
      _list = value.data!.items;
      for (int i = 0; i < _list!.length; i++) {
        _list![i].index = i;
      }
    }).whenComplete(() {
      _waiting.safeValue = false;
    });
  }

  void selectPackage(PackageItem packageItem) {
    _packageSelected = packageItem;
  }

  void sendPackage() {
    ConditionRequestData requestData = ConditionRequestData();
    requestData.packageId = _packageSelected.id;
    _repository.setCondition(requestData).then((value) {
      _navigateTo.fire({'url': value.next, 'params': _packageSelected});
    });
  }

  void setRepository() {
    _repository = Repository.getInstance();
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
  }
}
