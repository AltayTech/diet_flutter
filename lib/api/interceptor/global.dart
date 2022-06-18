import 'package:behandam/app/app.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/device.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
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
    if (!kIsWeb) options.headers['user-agent'] = await DeviceUtils.makeUserAgent();
    options.headers['Charset'] = 'UTF-8';
    print('auth token $authToken');
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['authorization'] = 'Bearer ${authToken}';
    }

    // options.headers['Fcm-Token'] = fcmToken;
    options.headers['App'] = '0';
    options.headers['market'] = FlavorConfig.instance.variables['market'];
    options.headers['Application-Version-Code'] = packageInfo.buildNumber;
    options.headers['version'] = packageInfo.version.replaceAll('.', '');
    options.headers['Application-Version-Name'] = packageInfo.version;
    options.headers['Platform'] = DeviceUtils.platform;
    options.headers['Platform-Version'] = await DeviceUtils.platformVersion;
    options.headers['X-Device'] = await DeviceUtils.deviceName;
    options.headers['Device-Id'] = await DeviceUtils.deviceId;
    options.headers['Is-Emulator'] = await DeviceUtils.isEmulator;
    options.headers['Time-Zone'] = DateTimeUtils.timezoneOffset;
    print(
        'global/ ${MemoryApp.forgetPass} / ${navigator.currentConfiguration?.path} / ${MemoryApp.token != null} / ${MemoryApp.token != 'null'}');
    if (MemoryApp.needRoute) {
      options.headers['x-route'] = MemoryApp.forgetPass
          ? '${navigator.currentConfiguration?.path.substring(1)}/forget'
          : navigator.currentConfiguration?.path.substring(1);
    }
    super.onRequest(options, handler);
  }
}
