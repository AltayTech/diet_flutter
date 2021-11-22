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
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiODgzNTBlYTE0NzM1NDFkMDBlZWE4NjIwYWY4NzUwNTQ2Mjg4MTZhNjdhZmU4YWY5MWVkOTRjYWVlM2JkNmQyNDc0MDYxNGE4MWNhODg2NjAiLCJpYXQiOjE2Mzc1NjE3MTIuOTQ4NjEsIm5iZiI6MTYzNzU2MTcxMi45NDg2MTgsImV4cCI6MTY2OTA5NzcxMi45MzY3MDgsInN1YiI6IjYzIiwic2NvcGVzIjpbXX0.Ec1AKyZ5sWh1UNsAWkW5i6KbdjjNWT1naecQM9uLE-23UQeITzW9Tc3S2zvsYsgEICFteDJ828v42rFUJamz-ilKdf9SHD7BgXHXzq97N9gKeAVh4d1nyQI0DYpfrOLXcfdPhmBkMqoafq7gzA_cOO_edYTH-kGb1PR60GPe8seUG9WR6sFe2_mQTFa7CQ-mgQ-bTl0Cm9N6ce-pm7kC8nHRCb9ElaXdoUFp_MartE3QdAmZViMBFC739a-hScBr-bV5A5C5ysGFj2mWyYu0jOz2ee27JhYlPzVaW-B78NxbTDYzygW942U8K2MRXJyzLhvFcVTFz6Jlf15ZFkyDPq6Q3UOUy_EYURE8l2ZIdVUlcjl2ZKMTX2zlVVpxwLmPbTJLRWjsLQDOFNYRcDsJBRt14NKEDehqbG8gg7G_uhf307rrQohNROaCrq5TnIBQ0xrsk6TA8ozbdmMpuBTfvkbLWRUhUt9pMsk0NhwRvKmRobgqPulOHemD3rDao3HcGQ-50XBTpkihRtyUMyVTlw5_ayDK2QD54xmCHSq_qer-BusqqsbVz7akLm1YhFwd6anVuSVapK5JQT6EfNsAZwJs9_Fqk4Aro6A2NW3mH2PkAZ_8LAThR2vMnFRGZDk3cgt3HRa4zlj0ajdEdMaI-88W2btL2aB-Xs3SMoVYTmY';
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
