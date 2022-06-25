import 'dart:async';
import 'dart:io';

import 'package:behandam/base/live_event.dart';
import 'package:behandam/base/repository.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/entity/user/version.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/stream.dart';
import 'package:behandam/extensions/string.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class SplashBloc {
  SplashBloc() {
    _waiting.safeValue = false;
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
    _versionApp.safeValue = version ?? '';
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

  void onRetryLoadingPage() {
    getUser();
  }

  void getUser() {
    _waiting.safeValue = true;
    if (MemoryApp.token.isNotNullAndEmpty) {
      checkFcm();

      _repository.getUser().then((value) {
        MemoryApp.userInformation = value.data;
        MemoryApp.analytics!.setUserId(id: MemoryApp.userInformation!.userId.toString());
        if (!kIsWeb)
          FirebaseCrashlytics.instance
              .setUserIdentifier(MemoryApp.userInformation!.userId.toString());
        MemoryApp.analytics!
            .setUserProperty(name: 'full_name', value: MemoryApp.userInformation!.fullName);
      }).whenComplete(() {
        if (!MemoryApp.isNetworkAlertShown) getVersionUpdate();
        _waiting.safeValue = false;
      });
    } else {
      getVersionUpdate();
    }
  }

  void getVersionUpdate() {
    if (!kIsWeb) {
      _waiting.safeValue = true;
      if (MemoryApp.token.isNotNullAndEmpty) {
        _repository.getVersion().then((value) async {
          checkVersionForceUpdate(value.data);
        }).catchError((onError) {

        }).whenComplete(() {
          _waiting.safeValue = false;
        });
      } else
        _navigateTo.fire(true);
    } else {
      _navigateTo.fire(true);
    }
  }

  void checkVersionForceUpdate(Version? version) {
    if (version != null && int.parse(version.versionCode!) > buildNumber!) {
      if (version.forceUpdate!) forceUpdate = true;
      if (version.forceUpdateVersion != null &&  int.parse(version.forceUpdateVersion!) > buildNumber!)
        forceUpdate = true;
      _showUpdate.fire(version);
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
