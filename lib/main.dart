import 'package:behandam/app/app.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Locale appInitialLocale;
final RouteObserver<PageRoute> routeObserver = RouteObserver();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Initialize flutter engine before mutating anything
  appInitialLocale = await _initializeLocale;
  updateStatusBar();
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://debug.behaminplus.ir/behandam-diet/api',
      "baseUrlFile": "https://behandam.kermany.com/helia-service",
      'isProduction': false
    },
  );
  runApp(App());
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
