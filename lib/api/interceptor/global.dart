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
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDg2YTE1MTk0NmQ5NzIyZTYyM2E1NWEyNGNiNzRjMTAyMTQxMDQwZDZhMTQ5NWEwMTRiMTkzMjU0MTMyNTY4YjRkNWI4ZTU4NjM4YjViNzIiLCJpYXQiOjE2MzU2NTgzNjYuODk1NjI2LCJuYmYiOjE2MzU2NTgzNjYuODk1NjM1LCJleHAiOjE2NjcxOTQzNjYuODg1MDIyLCJzdWIiOiI2MyIsInNjb3BlcyI6W119.sUMtyZUiQBp6CIYmFYdY2avwjto1BxplgiyK1OPwQ4cqPFRzJHqjj679piWvrB3oD-ModWc62mDgf8WWlY6xstARIB_da2dxve5cSLzOVDA-Vzo3NWFgRdXjPhAcPFS7eo2ZQj2-kHTfIvsszFrS5_PauirXeUElVMd7UMjfdNmrbCkrMPjN2ao2v8xlMvK46hSwrELPPQ6PBJphYH2We1Wl62lIYZWJjycDSUnRcd4RXi0KGhzZurZmOCtk96c_HRAqrLWzUyzhKNYs_uiAWwfXWLkwbJg8UEzpZmPa8ai8dIQpK7gE6SrWas0A19t_cADxSQJMU5oXI9bQNkHO8_uRKW0DEq5wy0eRQTLr1l8i2WA_9EUAQI_TtIzUOwGHjwxEU8feA6vXbXlEJ8IdUvycVBE8g-t3qUmYibW2YSqX_xeHZaVBfLyN1lXH4vxNffEnGvQfdwb3iTiftf3xZIZqo4G2XGYOoCOiBnjl2g0CuMTjIgglr9rX90sgwtexQzxNTuEpAsahPaH5QG2qroaaoZL3Htb-niUJdp1JPhWPzeckwMq8uW4MCHEKzmdB4K17M9mWIr4TerlZl-SJOlN9WEAmpFVRE8WAEjfWxj1BzO4xl3lB6R6ysYfsCmR_cS2swAZi6VyX8HeSaDWq8-ui0hKMvI9inC5yJnwsMRM';
    }
    // options.headers['Fcm-Token'] = fcmToken;
    options.headers['App'] = '0';
    options.headers['Application-Version-Code'] = packageInfo.buildNumber;
    options.headers['version'] = packageInfo.version.replaceAll('.', '');
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
