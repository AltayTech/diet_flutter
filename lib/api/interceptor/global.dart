import 'package:behandam/data/sharedpreferences.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/device.dart';
import 'package:logifan/extensions/string.dart';

class GlobalInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = await AppSharedPreferences.authToken;
    final packageInfo = await PackageInfo.fromPlatform();
    final languageCode = (await AppLocale.currentLocale).languageCode;
   // final fcmToken = await AppSharedPreferences.fcmToken;

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = languageCode.capitalize();
    options.headers['Charset'] = 'UTF-8';
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
   // options.headers['Fcm-Token'] = fcmToken;
    options.headers['Application-Id'] = packageInfo.packageName;
    options.headers['Application-Version-Code'] = packageInfo.buildNumber;
    options.headers['Application-Version-Name'] = packageInfo.version;
    options.headers['Platform'] = DeviceUtils.platform;
    options.headers['Platform-Version'] = await DeviceUtils.platformVersion;
    options.headers['Device-Name'] = await DeviceUtils.deviceName;
    options.headers['Device-Id'] = await DeviceUtils.deviceId;
    options.headers['Is-Emulator'] = await DeviceUtils.isEmulator;
    options.headers['Time-Zone'] = DateTimeUtils.timezoneOffset;
    super.onRequest(options, handler);
  }
}
