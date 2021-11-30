import 'dart:async';
import 'dart:io';
import 'package:behandam/data/memory_cache.dart';
import 'package:dio/dio.dart';
import 'package:behandam/app/app.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Locale appInitialLocale;
final RouteObserver<PageRoute> routeObserver = RouteObserver();
FirebaseAnalyticsObserver? firebaseAnalyticsObserver;
Future<void> entryPoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
    AppLocale.initialize();
    updateStatusBar();
    _handleCaughtErrors();
    _initFireBase();
    runApp(App());
  }, (Object error, StackTrace stack) {
    if (!(error is DioError || error is HttpException)) {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
void _initFireBase () async{
  try {
    await Firebase.initializeApp();

    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  } catch (Exception) {
    print("not install firebase");
  }
  try {
    MemoryApp.analytics = FirebaseAnalytics();
    firebaseAnalyticsObserver=FirebaseAnalyticsObserver(analytics: MemoryApp.analytics!);
  } catch (Exception) {
    print("not install FirebaseAnalytics");
  }
}

void updateStatusBar() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppMaterialColors.primary.shade800,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}
void _handleCaughtErrors() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    if (!(details.exception is DioError || details.exception is HttpException)) {
      FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
    }
  };
}