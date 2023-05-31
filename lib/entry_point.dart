import 'dart:async';
import 'dart:io';

import 'package:alarm/alarm.dart';
import 'package:behandam/app/app.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/fcm.dart';
import 'package:behandam/utils/firebase_options.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

late Locale appInitialLocale;
final RouteObserver<PageRoute> routeObserver = RouteObserver();
//FirebaseAnalyticsObserver? firebaseAnalyticsObserver;

Future<void> entryPoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
    await AppSharedPreferences.initialize();
    AppLocale.initialize();
    AppColors(themeAppColor: ThemeAppColor.BLUE);
    try {
      if (Platform.isAndroid) {
        DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
        var androidInfo = await deviceInfo.androidInfo;
        if (androidInfo.version.sdkInt >= 26) {
          await Alarm.init();
        }
      } else {
        await Alarm.init();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
    // _initFireBase();
    // _handleCaughtErrors();
    runApp(App());
  }, (Object error, StackTrace stack) async {
    print('error StackTrace => ${stack.toString()}');
    if (error is DioError || error is HttpException) {
      /// this kind of error is already handled in DioErrorHandlerInterceptor
      return;
    }
    //   FirebaseCrashlytics.instance.recordError(error, stack);
  });
}

void _initFireBase() async {
  try {
    await Firebase.initializeApp(
      options: await DefaultFirebaseConfig.platformOptions,
    );
    debugPrint('Firebase.app ${Firebase.apps.first.name}');
    await AppFcm.initialize();
    if (FirebaseCrashlytics.instance.isCrashlyticsCollectionEnabled == false) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }
    //FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (Exception) {
    print("not install firebase");
  }
  try {
    /*   MemoryApp.analytics = FirebaseAnalytics.instance;*/
    // firebaseAnalyticsObserver = FirebaseAnalyticsObserver(analytics: MemoryApp.analytics!);
  } catch (Exception) {
    print("not install FirebaseAnalytics");
  }
}

void _handleCaughtErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (!(details.exception is DioError || details.exception is HttpException)) {
      FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
    }
  };
}
