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
    if (authToken != 'null') {
      options.headers['authorization'] = 'Bearer ${MemoryApp.token}';
    } else {
      options.headers['authorization'] =
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDE4NTM2MWEzMjljMTI1YTZmOTc5M2ExZjU1ODMxM2FjNWU4OGU3Y2VhYjAyZTNlOGU0OGMwYWU4M2EyM2ViNDEyY2VjMTAzZDFmMTAzOTQiLCJpYXQiOjE2MzcyMzIyOTEuMjYxMDMyLCJuYmYiOjE2MzcyMzIyOTEuMjYxMDQsImV4cCI6MTY2ODc2ODI5MS4yNTQ0NTEsInN1YiI6IjgzNTcxNCIsInNjb3BlcyI6W119.Ac6678-3sOCVZjZGdYkxDrckSurvWscvl_m4C0rt4IfSbX7E8tZ6fGmILuuyYdlEcaFugRbO9VRspOxYcRmWQMaMgE4Snm5D832VjN82m214fyl3ElNDMAKGPG-HhcbfS7UmH0o-tTL98INdlzIsD_iy2slCPe8Wm3J_1LPHT6fZOlHa9M5R6RVpk2Q_v4WaVSrXW_tcB1IxOsFgLyyCiub4Cq1ejhcU5QZ2LZn0019jSLGIFUcwqyhCaDMcSMms7SdAnus2Sg-Wy70v61PcW8BAT67iFN8f8Zs5iDDYKis5bwSnFNg1KE3MEo1pDOS7whS3HO9L4mTct_sPV8VGsQf6Bg7LqAAzrYtGSOJBl4LmKxs65_-4v6iN958opJpqQRjT-LTCeZg4MDZpvhRx7nov8KY1IdFWIQsfDTTau6eUWDdwTLO2hbf2zw5STwkUVABI2dVB64q7u6aUp4ztEzqNmcxV9y2fVj0wZ208e348f-fWixrGLcl3GCCW4R8OTLBUw926TpVtjF4CBmfDEv9p0Rh4N5qbrpP3i8M-pD479AYgFX363XLBMlMt2QM4qCxb3O-O28xMstmB1_lH9qAxUDkI4j989XgwjFJuNFH3-tJW5gyBIPkrdxPGyVfZy7ZCmCVCvn1VfNVJaU_9R0ttCFaEpuQrrpHnRlHsfHA';
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
      options.headers['x-route'] =
          navigator.currentConfiguration?.path.substring(1);
    }
    super.onRequest(options, handler);
  }
}
