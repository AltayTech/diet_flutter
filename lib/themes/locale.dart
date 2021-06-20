import 'package:flutter/material.dart';

/// Application supported languages
abstract class AppLocale {
  static const ar = Locale('ar');
  static const en = Locale('en');
  static const fa = Locale('fa');

  static const defaultLocale = fa;
  static const supportedLocales = [
    ar,
    en,
    fa,
  ];
}
