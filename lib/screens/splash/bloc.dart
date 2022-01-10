import 'dart:async';
import 'dart:io';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';

class SplashBloc {
  SplashBloc() {
    _waiting.value = false;
    if (!kIsWeb)
      SmsAutoFill().getAppSignature.then((value) {
        debugPrint('package is $value');
      });
  }

  final _repository = Repository.getInstance();

  late String _path;

  final _waiting = BehaviorSubject<bool>();
  final _versionApp = BehaviorSubject<String>();
  final _showUpdate = LiveEvent();
  final _navigateTo = LiveEvent();

  String get path => _path;

  Stream<bool> get waiting => _waiting.stream;

  Stream<String> get versionApp => _versionApp.stream;

  Stream get showUpdate => _showUpdate.stream;

  Stream get navigateTo => _navigateTo.stream;
  String? version;
  String? packageName;
  int? buildNumber;
  bool forceUpdate = false;

  void getPackageInfo() async {
    version = await Utils.versionApp();
    _versionApp.value = version ?? '';
    buildNumber = await Utils.buildNumber();
    packageName = await Utils.packageName();
  }

  void checkFcm() async {
    String fcm = await AppSharedPreferences.fcmToken;
    bool sendFcm = await AppSharedPreferences.sendFcmToken;
    if (fcm != 'null' && !sendFcm)
      _repository.addFcmToken(fcm).then((value) async {
        await AppSharedPreferences.setSendFcmToken(true);
      });
  }

  void getUser() {
    _waiting.value = true;
    if (MemoryApp.token != null) {
      checkFcm();
    }
    _repository.getUser().then((value) {
      MemoryApp.userInformation = value.data;
      MemoryApp.analytics!.setUserId(id: MemoryApp.userInformation!.userId.toString());
      if (!kIsWeb)
        FirebaseCrashlytics.instance
            .setUserIdentifier(MemoryApp.userInformation!.userId.toString());
      MemoryApp.analytics!
          .setUserProperty(name: 'full_name', value: MemoryApp.userInformation!.fullName);
    }).whenComplete(() {
      if(!_waiting.isClosed)
      _waiting.value = false;
      getVersionApp();
    });
  }

  void getVersionApp() {
    if (!kIsWeb) {
      _waiting.value = true;
      _repository.getVersion().then((value) async {
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
          //debugPrint('onError = > ${value.data!.android!.toJson()} // $buildNumber');
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
      }).catchError((onError) {
        print('onError = > ${onError}');
      }).whenComplete(() {
        if (!_waiting.isClosed) _waiting.value = false;
      });
    } else {
      _navigateTo.fire(true);
    }
  }

  void dispose() {
    _waiting.close();
    _versionApp.close();
    _showUpdate.close();
    _navigateTo.close();
  }
}
