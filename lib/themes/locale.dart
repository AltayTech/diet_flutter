import 'package:behandam/data/sharedpreferences.dart';
import 'package:flutter/material.dart';

Locale appInitialLocale = AppLocale.defaultLocaleForPreview;

/// Application supported languages
abstract class AppLocale {
  static const ar = Locale('ar');
  static const en = Locale('en');
  static const fa = Locale('fa');

  static const defaultLocale = ar;
  static const defaultLocaleForPreview = ar;
  static const supportedLocales = [
    ar,
    en,
    fa,
  ];

  static Future<Locale> get currentLocale async => Locale(await AppSharedPreferences.localeCode);

  static Future<bool> get isLocaleFreeOfDietCharge async => (await currentLocale) != AppLocale.ar;

  static Future<List<Locale>> get otherLocales async {
    final current = await currentLocale;
    switch (current.languageCode) {
      case 'fa':
        return [en, ar];
      case 'ar':
        return [fa, en];
      case 'en':
        return [fa, ar];
      default:
        throw 'Current locale ${current.languageCode} is not included in switch statement';
    }
  }

  static Future<void> initialize() async {
    appInitialLocale = await currentLocale;
  }

  static Future<void> setCurrentLocale(Locale locale) async {
    appInitialLocale = locale;
    await AppSharedPreferences.setLocaleCode(locale.languageCode);
  }

  static bool isRtl(Locale locale) {
    return locale.languageCode == fa.languageCode || locale.languageCode == ar.languageCode;
  }
}
