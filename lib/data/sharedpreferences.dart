
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/themes/locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AppSharedPreferences {
  static late SharedPreferences preference;
  static Future<void> initialize() async {
    preference = await SharedPreferences.getInstance();
  }

  static Future<String?> _getString(String key) async {
    final result = preference.getString(key);
    return result == _nullString ? null : result;
  }
  static Future<String?> get authToken async {
    return preference.getString(_keyAuthToken) ?? null;
  }

  static Future<void> setAuthToken(String? value) async {
    MemoryApp.token = value;
    preference.setString(_keyAuthToken, value ?? '');
  }

  static Future<bool> get isLoggedIn async {
    return preference.getBool(_keyIsLoggedIn) ?? false;
  }

  static Future<void> setIsLoggedIn(bool value) async {
    preference.setBool(_keyIsLoggedIn, value);
  }

  static Future<String> get localeCode async {
    return preference.getString(_keyLocaleCode) ?? AppLocale.defaultLocale.languageCode;
  }

  static Future<void> setLocaleCode(String value) async {
    (await preference).setString(_keyLocaleCode, value);
  }
  static Future<void> logout() async {
    await setAuthToken(null);
    await setIsLoggedIn(false);
    MemoryApp.token = null;
  }

  static Future<String?> get deeplink async {
    return await _getString(_keyDeeplink);
  }

  static Future<void> setDeeplink(String? deeplink) async {
    preference.setString(_keyDeeplink, deeplink ?? _nullString);
  }
  static Future<String> get fcmToken async {
    return preference.getString(_keyFcmToken) ?? _nullString;
  }

  static Future<void> setFcmToken(String? token) async {
    preference.setString(_keyFcmToken, token ?? _nullString);
  }

  static Future<String?> get fcmPushAction async {
    return await _getString(_keyFcmPushAction);
  }

  static Future<void> setFcmPushAction(String? pushAction) async {
    preference.setString(_keyFcmPushAction, pushAction ?? _nullString);
  }

  static Future<String?> get fcmButtonActions async {
    return await _getString(_keyFcmButtonActions);
  }

  static Future<void> setFcmButtonActions(String? notifResponse) async {
    preference.setString(_keyFcmButtonActions, notifResponse ?? _nullString);
  }

  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyAuthToken = 'authToken';
  static const _keyLocaleCode = 'localeCode';
  static const _keyFcmPushAction = 'fcmPushAction';
  static const _keyFcmButtonActions = 'fcmButtonActions';
  static const _keyFcmToken = 'fcmToken';
  static const _nullString = 'null';
  static const _keyDeeplink = 'deeplink';
}