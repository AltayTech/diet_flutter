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
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNGZkZTg5ODM2YTA2OWIwYWM4YTk0YThlMWY5YzEwMjk1NTA4M2ViZDU0MDg1ZWZiMDMzZDRmYTU5ZGUxMGExMTM1N2Q4MjA3MWZkMDNlZGYiLCJpYXQiOjE2Mzc1NzI5MzcuMzg0ODA0LCJuYmYiOjE2Mzc1NzI5MzcuMzg0ODA5LCJleHAiOjE2NjkxMDg5MzcuMzc3MzU5LCJzdWIiOiI4MzU4ODciLCJzY29wZXMiOltdfQ.tDiwkYnxHKQcrF7CpXoNU45Bq9Bb6jK99WSArxullE5Qgu48Vxhwe6kQ7wVuN-gNC9rioGuIMsrKweZ0BtJiigsNp9-qBQ2HzP1ODLff0zEdGrQrjYF3m2-z_nTViIwTjw6bZ5Cqfmt0ZlYsFoDv2pE5zAYWwlSQPcoYiFMEFOthEtMPv_JYEnxDDeWr52ZmgJbsOxy1cgosoU6sZ3phjaP3SCKocJzqoH908HD-6bPtC7liiQCk6G5OZr9tDaA7pRPhumZECQudnAPmtm9tf1zGwhuBab1fsiZeuGDwnm_6AXIzHJmkWMZrkYT0_H8y_qynPZFa1TlJ9xK8C56-8AUb4mt2p7oP8sVycEAzLfEYt2Hh0BgIPeRqfB0ufE9hcwopdkMUKL0zg-O39yJa5R5A52O9OajakrrH7t3jGFRN8g1JVXxExDNvtxbGDfNiGJLV4oIq0UIHg8YwsSqCRnem-PfgEK5oGIT8ttFiScHUnJY9_Yy0nM6AGWHaGRlNPih5dTHqACh349IhCgt7jklwJEyZNVD_VSFKFYHKYn_85YOgQJF0AX9_nAes9lwMgJ36tb5U5vlWXjHRn_jc0pQF9GmSoTbk3Uq_ur6pS_PK3Jyw_SsqBTvwdJ0M3-IlE98uRu10bxvLzZ1b6aYwTnAV6LzV735amktrbtR7I_8';
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
