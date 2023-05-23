import 'package:behandam/data/memory_cache.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Crashlytics
/// Only supported for iOS and Android
abstract class AppAnalytics {
  static FirebaseAnalytics get _instance => FirebaseAnalytics.instance;

  static FirebaseAnalytics get instance => _instance;

  static Future<void> initialize() async {
    if (kIsWeb) {
      // not supported on web
      return;
    }
    await setUserId();
  }

  static Future<void> setUserId() async {
    final userId = MemoryApp.userInformation?.userId;
    final fullName = MemoryApp.userInformation?.fullName;
    _instance.setUserId(id: '$userId');
    _instance.setUserProperty(name: 'name', value: '$fullName');
  }

  static Future<void> logEvent({required String name, Map<String, Object?>? value}) async {
    if (kIsWeb) {
      // not supported on web
      return;
    }

    try {
      _instance.logEvent(name: name, parameters: value);
    } catch (e) {}
    return;
  }
}
