import 'dart:async';
import 'dart:io';

import 'package:behandam/app/app.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/fcm.dart';
import 'package:behandam/utils/firebase_options.dart';
import 'package:dio/dio.dart';
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
  GooglePlay('GooglePlay'),
  CafeBazaar('CafeBazaar'),
  Myket('Myket'),
  Iapps('Iapps');

  const Market(this.value);

  final String value;
}

Future<void> entryPoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
    Vx.setPathUrlStrategy();
    _initializeDebugPrint();
    await AppSharedPreferences.initialize();
    AppLocale.initialize();
    AppColors(themeAppColor: ThemeAppColor.DEFAULT);
    _initFireBase();
    _handleCaughtErrors();
    runApp(App());
  }, (Object error, StackTrace stack) async {
    if (error is DioError || error is HttpException || error is SocketException) {
      debugPrint("error is => ${error.toString()}");
      return;
    }
    if (!kIsWeb) {
      debugPrint("error is => ${error.toString()}");
      FirebaseCrashlytics.instance.recordError(error, stack);
    } else {
      debugPrint("error is => ${error.toString()}");
      debugPrint("error is => ${stack.toString()}");
    }
  });
}

void _initializeDebugPrint() {
  if (kReleaseMode || kIsWeb) {
    debugPrint = (String? message, {int? wrapWidth}) => doNothing();
  }
}

void _initFireBase() async {
  try {
    await Firebase.initializeApp(
      options: await DefaultFirebaseConfig.platformOptions,
    );
    await AppFcm.initialize();
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

void _handleCaughtErrors() {
  if (!kIsWeb) {
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      if (!(details.exception is DioError ||
          details.exception is HttpException ||
          details.exception is SocketException)) {
        FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
      }
    };
  }
}
