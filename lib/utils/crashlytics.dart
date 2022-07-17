import 'package:behandam/data/memory_cache.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Firebase Crashlytics
/// Only supported for iOS and Android
abstract class AppCrashlytics {
  static FirebaseCrashlytics get _instance => FirebaseCrashlytics.instance;

  static Future<void> initialize() async {
    if (kIsWeb) {
      // not supported on web
      return;
    }
    if (_instance.isCrashlyticsCollectionEnabled == false) {
      await _instance.setCrashlyticsCollectionEnabled(true);
    }
    await setUserId();
  }

  static Future<void> setUserId() async {
    final userId = MemoryApp.userInformation?.userId;
    final fullName = MemoryApp.userInformation?.fullName;
    _instance.setUserIdentifier('$userId');
    setCustomKey('full_name', fullName ?? 'ناشناس');
  }

  static Future<void> setCustomKey(String key, Object value) async {
    if (kIsWeb) {
      // not supported on web
      return;
    }
    return _instance.setCustomKey(key, value);
  }

  static Future<void> recordFlutterError(FlutterErrorDetails flutterErrorDetails) async {
    if (kIsWeb) {
      // not supported on web
      return;
    }
    return _instance.recordFlutterError(flutterErrorDetails);
  }

  static Future<void> recordError(
    dynamic exception, {
    StackTrace? stack,
    dynamic reason,
    Iterable<DiagnosticsNode> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) async {
    if (kIsWeb) {
      // not supported on web
      return;
    }
    return _instance.recordError(
      exception,
      stack ?? StackTrace.current,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }
}
