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
    options.headers['user-agent'] = DeviceUtils.makeUserAgent();
    options.headers['Charset'] = 'UTF-8';
    // if (authToken != null) {
    //   options.headers['authorization'] = 'Bearer ${authToken}';
    // }
    // else {
       options.headers['authorization'] =
           'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiYzZjMDUwOTIzZDZhMmExODM0OWU2MTg5YmFhNjM4NzQ1Nzg3OTk0N2RiNGI0MWRlYWM0MGI0NzMyZjhlMmFlMjJmZGM5Zjk0NWQyNzE1MjEiLCJpYXQiOjE2MzgyNzA1NDcuNjk4NjczLCJuYmYiOjE2MzgyNzA1NDcuNjk4NjgyLCJleHAiOjE2Njk4MDY1NDcuNjkyMDAyLCJzdWIiOiIxNjAyOTEyIiwic2NvcGVzIjpbXX0.ijdnyzOFWp325lIy6j3UUbWeaN8D_gkT2xafasUcrqKRBKZLS5rJY2Hel2ul0HnB3Z56EY2JM9HZ9FV8Ewvoa0MDpY3HbGyrdjCbmqOkGZQcDKlXZiovBu9G9__Xjjow5w_58UlP60XeBwKjYGOn32DieOui9No_MdcKMvNVweU2t8gAzl-0A5DAC6pSalpyHe3t191GQc7Gfa4oSoFyUVjfuLQymCfI0BBKgzv36kzW3jtZ1H29mDOD2MzfYpKj2IYOv4GoV3YApLJwPglSPz6C4J466szCOCaAT4RQqx14ag846Y-D_IDSYlAJ9ZSoGS3SFUWJzfbDJRIdtmGMBpJcmwQkQibMV2S0X8B46mQPaJu9Sdn2okMmV1BN_ebhLDFukf_rUVP1JTPzm4c6KEXsvXExVWvySc1MNMGg-hIMrZciVYkAbKTNL1zbFTVoA-kUcHHWt7eVRfYOiOCbHt8Ol0QYXRMGGk5Gz0JEFkqzmJ8XP1dH4GPqkdjy7AKTse3GcoiwTMmGi7SGL14zZk1XKXXqBET7PbAZKxsu0bPSWf3afji9MQQS6I1wy_8GAliNRD4_RliDd87U_Yl63bt0K3zksdjw_OFXQk53syL2gmiC6hoHnCfoyPeyyd6UCGXUmDCF9OL5H1IIMB8C1RtcYmpF10Ws8HaON6zuhjo';
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
        'global ${navigator.currentConfiguration?.path} / ${MemoryApp.token != null} / ${MemoryApp.token != 'null'}');
    if (MemoryApp.needRoute) {
      if (navigator.currentConfiguration?.path.substring(1).isEmpty == true) {
        options.headers['x-route'] = Routes.listView.substring(1);
      } else {
        options.headers['x-route'] =
            navigator.currentConfiguration?.path.substring(1);
      }
    }
    super.onRequest(options, handler);
  }
}
