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
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYmMwMWQ4MzJhZTNkNGQ3ODJhMDFjYzI0OTA1YjllZWZhYzlkMGJlNGM4M2Q4YmM2OTY3OGQ0M2ZkMWI5ZTBiNDI2ZTkyMDEwYzhlZWQzZTUiLCJpYXQiOjE2MzYyNjczMTcuNjI2OTc1LCJuYmYiOjE2MzYyNjczMTcuNjI2OTg5LCJleHAiOjE2Njc4MDMzMTcuNjE1NDMzLCJzdWIiOiI4MzYwMjIiLCJzY29wZXMiOltdfQ.jUYSGRfLfVsCYu3JDbK21qEhl0Q1VSVrAABIC5LAAxuNpVmhUXMjsJKYVCkDXMZ2Xa1ZQIPBzfXXMNvUEGo2pUzjo08Pi5rMTf11d9g4KKOlsKHImMUb1TYK7ouRTq0bFezXvy_d4QL_ZckPTwvixe3F8jsB416tql3C7Zm9dgNI3X1lZCCkrNy8n5WwUlCCQkMdZuSs9OduwkaWLr-hX3LO5aMkF-Y-Ona90kL0URv2gu_He2Jwg1EhYXvWCeMkbAifKFZnMaCUK9N3JSY_i0zHD-ki_hOupsXjiiWRYiK2BJbu71asihEGemaf03EZZzm8_GlzDxQ1WxTXRw30WQwjvb2mb4_dFvR6aWZsReis7WXWclxnE_s5GiGMm6FjUaq4tDZQ3DosqSodl4Uhi_djp_wzwWoZbKkzjbr7m3ulBrzbjG0LurzL_vg4AEjWeV9KYzah9J33_AlIaRkO7I8jeRIfx1Hbz41XeLwu2K4NfoiCHUNKQdTG6AgCDCVk4Tqbmy21IjmatuPJJzvw3nRR987nDCDZZOqsgtjt-irzpGEyX011S_bNMNBx7CJ090wgl8V7-QAIXCxeqexHMk3cQSwzt3atBGZQfiNitrvoJ_cjgo44yZm4zB0_dB19dOA2bjESgZ0JBLWkajXTJ0iNtzIZTfqFuW-mwv2gmQU';
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
