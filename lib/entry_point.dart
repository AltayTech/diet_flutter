import 'dart:async';

import 'package:behandam/app/app.dart';
import 'package:behandam/base/errors.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/crashlytics.dart';
import 'package:behandam/utils/fcm.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logifan/base/first_class_functions.dart';
import 'package:velocity_x/velocity_x.dart';

late Locale appInitialLocale;
final RouteObserver<PageRoute> routeObserver = RouteObserver();

//FirebaseAnalyticsObserver? firebaseAnalyticsObserver;
enum Market {
  google('google'),
  cafebazaar('cafebazaar'),
  myket('myket'),
  iapps('iapps');

  const Market(this.value);

  final String value;
}

Future<void> entryPoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
    Vx.setPathUrlStrategy();
    await initialNeededApp();
    runApp(App());
  }, GlobalErrorHandler.handleUncaughtErrors);
}

Future<bool> initialNeededApp() async {
  _initializeDebugPrint();
  await AppSharedPreferences.initialize();
  AppLocale.initialize();
  AppColors(themeAppColor: ThemeAppColor.DEFAULT);
  _initFireBase();
  GlobalErrorHandler.handleCaughtErrors();
  return Future.delayed(
    Duration(milliseconds: 100),
    () => true,
  );
}

void _initializeDebugPrint() {
  if (kReleaseMode || kIsWeb) {
    debugPrint = (String? message, {int? wrapWidth}) => doNothing();
  }
}

void _initFireBase() async {
  try {
    await Firebase.initializeApp();
    await AppFcm.initialize();
    await AppCrashlytics.initialize();
    if (!kIsWeb) {
      if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == false) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      }
    }

    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (Exception) {
    print("not install firebase");
  }

  try {
    MemoryApp.analytics = FirebaseAnalytics.instance;
    // firebaseAnalyticsObserver = FirebaseAnalyticsObserver(analytics: MemoryApp.analytics!);
  } catch (Exception) {
    print("not install FirebaseAnalytics");
  }
}
