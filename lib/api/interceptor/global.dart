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
  String? alternativeUrl;

  GlobalInterceptor(String? url) {
    alternativeUrl = url;
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = await AppSharedPreferences.authToken;
    final fcmToken = await AppSharedPreferences.fcmToken;
    final packageInfo = await PackageInfo.fromPlatform();
    final languageCode = (await AppLocale.currentLocale).languageCode;

    options.headers['accept'] = 'application/json';
    options.headers['content-type'] = 'application/json';
    options.headers['accept-language'] = languageCode;
    if (!kIsWeb) options.headers['user-agent'] = await DeviceUtils.makeUserAgent();
    options.headers['charset'] = 'UTF-8';

    if (alternativeUrl != null && alternativeUrl == FlavorConfig.instance.variables['baseUrlCrm']) {
      options.headers['token'] = 'nz9XS54cGdjV7nfPfJ7nEHuUmQP3kGm2rymF';
    } else {
      if (authToken != null && authToken.isNotEmpty) {
        options.headers['authorization'] = 'Bearer ${authToken}';
      }
    }

    options.headers['app'] = '0';
    options.headers['market'] = FlavorConfig.instance.variables['market'];
    options.headers['application-version-code'] = packageInfo.buildNumber;
    options.headers['version'] = packageInfo.version.replaceAll('.', '');
    options.headers['application-version-name'] = packageInfo.version;
    options.headers['os'] = DeviceUtils.platform;
    options.headers['x-device'] = await DeviceUtils.deviceName;
    options.headers['device-id'] = await DeviceUtils.deviceId;
    options.headers['fcm-token'] = fcmToken;
    options.headers['is-emulator'] = (await DeviceUtils.isEmulator).toString();
    options.headers['time-zone'] = DateTimeUtils.timezoneOffset.toString();
    if (MemoryApp.needRoute) {
      options.headers['x-route'] = navigator.currentConfiguration?.path.substring(1);
    }
    super.onRequest(options, handler);
  }
}
