import 'package:karsu/themes/locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSharedPreferences {

  static Future<SharedPreferences> get preference async => await SharedPreferences.getInstance();

  static Future<String> get authToken async {
    return (await preference).getString(_keyAuthToken) ?? 'null';
  }

  static Future<void> setAuthToken(String value) async {
    (await preference).setString(_keyAuthToken, value);
  }

  static Future<bool> get isLoggedIn async {
    return (await preference).getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setIsLoggedIn(bool value) async {
    (await preference).setBool(_keyIsLoggedIn, value);
  }

  static Future<String> get localeCode async {
    return (await preference).getString(_keyLocaleCode) ?? AppLocale.defaultLocale.languageCode;
  }

  static Future<void> setLocaleCode(String value) async {
    (await preference).setString(_keyLocaleCode, value);
  }


  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyAuthToken = 'authToken';
  static const _keyLocaleCode = 'localeCode';
}