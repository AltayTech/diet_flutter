import 'package:behandam/app/app.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/device.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GlobalInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = await AppSharedPreferences.authToken;
    final packageInfo = await PackageInfo.fromPlatform();
    final languageCode = (await AppLocale.currentLocale).languageCode;
    // final fcmToken = await AppSharedPreferences.fcmToken;

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = languageCode;
    options.headers['user-agent'] = DeviceUtils.makeUserAgent();
    options.headers['Charset'] = 'UTF-8';
    if (authToken != 'null') {
      options.headers['authorization'] = 'Bearer ${MemoryApp.token}';
    } else {
      options.headers['authorization'] =
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMmI2NDZiZGQ4NDEwNGM2NTY1N2FmYzA1NTYxMzQ0OTJkZTIzYTFmNGNmYWRkNmZhY2UzNjdlNGIxYjdhYzhiODg4MGFlMTA1OTJjM2RkZWUiLCJpYXQiOjE2MzI5OTI0OTkuNDYwNjM5LCJuYmYiOjE2MzI5OTI0OTkuNDYwNjQ0LCJleHAiOjE2NjQ1Mjg0OTkuNDUyNjk5LCJzdWIiOiI4MzU3MTQiLCJzY29wZXMiOltdfQ.lgfvWi6gju_6J99qWsQtO3Je7-8yzS7UwzTC3nkoJ9pLS80uuGY-LEXJya2m8aqRBR3X9OoUEJo2WxMOZXiUcPZOvh2B2RqcWSNyWfUlD0uUulVBDxvRyXF0VXpOuLqzUG8s89Ju23USneuDd2px88VTR83VuzJID7Nfb2N5NSO1F_rciqNj6r-rCZ8ONk68eDYLwzuXyRVbW9iZZc34VXjeBSckCjTtiq3jHEaEeYGql0B6GTDMaRjDNDQxmA8drdrVbfVlDAOz0LsEl8bcFp1XDPXZK55mTVHvbrq4BgzMGdUDKFZixTrOyoMQ5lj2THQT1rAEF_96p6nqEw6ZiyxuQRDbNu0h9IrzkNPuGuC5b7pDdeMBQd0b59FDDAcMybsszvqiALK5nSECNdRkOtLh7e4h-I3oCg4lm912t0tZ_1RQY9WTPJEtBp-_BeY-i-BpUSNO5jyW7LjdIKBI3oyLNRwEUKlMbcy8tDGc6FZQT5VCnsdnSk8FzuftUuY37VZV9owyx3RqFXWUX4pDRBKEFayMq7pNpgPeFOi0B6RtdzrHY1FqDrIp2g2zJW4Zuy8rdQMPxVTfb-8pf-wpj3ZIsA8khrz8yd5XGlVrKPJl_HqjDfyTM4dh04KbaZup08T-Gs0g2hEPiU0WUN8qc4XUenIEEE2EW6cHCZU3cxk';
    }
    // options.headers['Fcm-Token'] = fcmToken;
    options.headers['App'] = '0';
    options.headers['Application-Version-Code'] = packageInfo.buildNumber;
    options.headers['Application-Version-Name'] = packageInfo.version;
    options.headers['Platform'] = DeviceUtils.platform;
    options.headers['Platform-Version'] = await DeviceUtils.platformVersion;
    options.headers['X-Device'] = await DeviceUtils.deviceName;
    options.headers['Device-Id'] = await DeviceUtils.deviceId;
    options.headers['Is-Emulator'] = await DeviceUtils.isEmulator;
    options.headers['Time-Zone'] = DateTimeUtils.timezoneOffset;
    if (navigator.currentConfiguration?.path.substring(1).isEmpty == true) {
      options.headers['x-route'] = Routes.listView.substring(1);
    } else {
      options.headers['x-route'] = navigator.currentConfiguration?.path.substring(1);
    }
    super.onRequest(options, handler);
  }
}
