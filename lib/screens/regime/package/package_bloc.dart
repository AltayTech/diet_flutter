import 'dart:async';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:rxdart/rxdart.dart';

class PackageBloc {
  PackageBloc() {
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  late String _path;
  List<PackageItem>? _list;

  final _waiting = BehaviorSubject<bool>();
  final _navigateTo = LiveEvent();
  final _showServerError = LiveEvent();

  String get path => _path;

  List<PackageItem>? get list => _list;

  Stream<bool> get waiting => _waiting.stream;

  Stream get navigateTo => _navigateTo.stream;

  Stream get showServerError => _showServerError.stream;

  void getPackage() {
    _waiting.value = true;
    _repository.getPackagesList().then((value) {
      _list = value.data!.items;
      for (int i = 0; i < _list!.length; i++) {
        _list![i].index = i;
        _list![i].services!.addAll(_list![i].products!);
      }
    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void dispose() {
    _showServerError.close();
    _navigateTo.close();
    _waiting.close();
  }
}
