import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:behandam/app/app.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Locale appInitialLocale;
final RouteObserver<PageRoute> routeObserver = RouteObserver();

Future<void> entryPoint() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
    AppLocale.initialize();
    updateStatusBar();
    _handleCaughtErrors();
    runApp(App());
  }, (Object error, StackTrace stack) {
    if (!(error is DioError || error is HttpException)) {
     // FirebaseCrashlytics.instance.recordError(error, stack);
    }
  });
}
Future<Locale> get _initializeLocale async {
  final localeCode = await AppSharedPreferences.localeCode;
  return Locale(localeCode);
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
    //  FirebaseCrashlytics.instance.recordError(details.exception, details.stack);
    }
  };
}