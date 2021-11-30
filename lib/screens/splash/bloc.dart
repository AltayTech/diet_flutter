import 'dart:async';
import 'dart:io';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SplashBloc {
  SplashBloc() {
    _waiting.value = false;
  }

  final _repository = Repository.getInstance();

  late String _path;

  final _waiting = BehaviorSubject<bool>();
  final _showUpdate = LiveEvent();
  final _navigateTo = LiveEvent();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream get showUpdate => _showUpdate.stream;

  Stream get navigateTo => _navigateTo.stream;
  String? version;
  String? packageName;
  int? buildNumber;
  bool forceUpdate = false;

 void getPackageInfo() async {
    version = await Utils.versionApp();
    buildNumber = await Utils.buildNumber();
    packageName = await Utils.packageName();
  }

  void getUser() {
    _waiting.value = true;
    _repository.getUser().then((value) {
      MemoryApp.userInformation = value.data;
    }).whenComplete(() {
      _waiting.value = false;
      getVersionApp();
    });
  }

  void getVersionApp() {
    _waiting.value = true;
    _repository.getVersion().then((value) async {
      if (!kIsWeb) {
        if (Platform.isIOS) {
          if (value.data?.ios != null && int.parse(value.data!.ios!.versionCode!) > buildNumber!) {
            if (value.data!.ios!.forceUpdate == 1) forceUpdate = true;
            if (value.data!.ios!.versionCode != null &&
                value.data!.ios!.forceUpdateVersion! > buildNumber!) forceUpdate = true;
            _showUpdate.fire(value.data!.ios);
          } else {
            _navigateTo.fire(true);
          }
        } else if (Platform.isAndroid) {
          print('onError = > ${value.data!.android!.toJson()} // $buildNumber');
          if (value.data?.android != null &&
              int.parse(value.data!.android!.versionCode!) > buildNumber!) {
            if (value.data!.android!.forceUpdate == 1) forceUpdate = true;
            if (value.data!.android!.versionCode != null &&
                value.data!.android!.forceUpdateVersion! > buildNumber!) forceUpdate = true;
            _showUpdate.fire(value.data!.android);
          } else {
            _navigateTo.fire(true);
          }
        }
      } else {
        _navigateTo.fire(true);
      }
    }).catchError((onError) {
      print('onError = > ${onError}');
    }).whenComplete(() {
      _waiting.value = false;
    });
  }

  void dispose() {
    _waiting.close();
    _showUpdate.close();
    _navigateTo.close();
  }
}
