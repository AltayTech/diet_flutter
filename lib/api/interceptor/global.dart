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
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final authToken = await AppSharedPreferences.authToken;
    final packageInfo = await PackageInfo.fromPlatform();
    final languageCode = (await AppLocale.currentLocale).languageCode;
    // final fcmToken = await AppSharedPreferences.fcmToken;

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = languageCode;
    options.headers['user-agent'] = await DeviceUtils.makeUserAgent();
    options.headers['Charset'] = 'UTF-8';
    print('auth token $authToken');
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['authorization'] = 'Bearer ${authToken}';
    }
    // else {
    //   options.headers['authorization'] =
    //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNTAzMzkyZmRhZGMyYzQzNDFjODk4MTkxOGFiMTk4MzgxMjk3M2RhNWJlMTAxZGYwZTllYzBmYzc5NjNmMjZlMjJmN2JhN2E1MjViZTBiMGIiLCJpYXQiOjE2Mzg0MjkzNjcuNjkxODY0LCJuYmYiOjE2Mzg0MjkzNjcuNjkxODczLCJleHAiOjE2Njk5NjUzNjcuNjgwODExLCJzdWIiOiIxNjAyOTEyIiwic2NvcGVzIjpbXX0.QHl3Wf_bJaLNg0koWvLkkrkkcnbUhVKpOvAvP96GgNKz0WgBbJGk7gwDnEdbZixOKvqS_xENkXTid0DRN_-IOHbhnvY9zuk3XCEJtsX_herF8qQljnsRH60KJoZ1k-MnwsItE0TuiNN5bkUcHR8ogUpOz4w6LDBlIT23dlbPDsHD4hk5qntOEp-6y4fc5zXxMlWI3z4i0zMeZ9OSYyPxh9ZuH20WiMz-PyG4_8kchbdvpd8BohvsjnMaCVKs99gakCX_-ZcUINVAXqUtGLaUaNBLe_QZBepItkmLpHpIvi83_uqtejlV67K7JJhoYanoSfFgIv2Cml6-PsBdhSq05JfFIRUeQPIANPSXsNSJ_B8eGLw1onC0LAuva4RPmPVgX6E1YExcDtC0R2e3Kx-nxpFNHT-EQgLYb3yJQor6KADASwc5xhKXrbRIZI23-XtddpqwkNwCTVkDxe7XmmBie5mw8WQw7MWVzTUeAk1DJVNZg7Vv92LnGrtDZCGhDODTep-VPyeRlIrrD1o24cjw0iW0wW4sIqN0QXlGuy_Wz9Ap7faJyqnrynucjUCBPTzMelsiEIUp3wzOXL8Y5jUAd7fDBKzuk-yZZTsHnO8u8S2riyeHuVogvCRCyz8AM9UokTuWK9a5kexUkhKFSrUqwxmjL0t6vU7-LD-4yjhunjA';
    // }
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
    print(
        'global/ ${MemoryApp.forgetPass} / ${navigator.currentConfiguration?.path} / ${MemoryApp.token != null} / ${MemoryApp.token != 'null'}');
    if(MemoryApp.needRoute){
      if (navigator.currentConfiguration?.path.substring(1).isEmpty == true) {
        options.headers['x-route'] = Routes.listView.substring(1);
        // options.headers['x-route'] = 'auth';
      } else {
        options.headers['x-route'] = MemoryApp.forgetPass
            ? '${navigator.currentConfiguration?.path.substring(1)}/forget'
            : navigator.currentConfiguration?.path.substring(1);
      }
    }
    super.onRequest(options, handler);
  }
}
