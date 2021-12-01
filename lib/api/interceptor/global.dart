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
    print('auth token $authToken');
    if (authToken != null && authToken.isNotEmpty) {
      options.headers['authorization'] = 'Bearer ${authToken}';
    }
    // else {
    //   options.headers['authorization'] =
    //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiN2U0YThiZWMxYWQyODJkNGYxNGU1ZmQ2MGJhOThkOTQyZGVjZmIzMjU3NDI3NDJiNDhjZmMxMGQzZTM1N2Y4ZTU3NTlmNWQ1MGVhMTdjMjMiLCJpYXQiOjE2MzgxNjY4MzIuNDUzNjg2LCJuYmYiOjE2MzgxNjY4MzIuNDUzNjk1LCJleHAiOjE2Njk3MDI4MzIuNDQwOTQxLCJzdWIiOiI2MyIsInNjb3BlcyI6W119.PQNl8dHpauG-QdUXhtEhV3UsB652CuJePfYa5rE_4tDe4qiDiuF8345Y-LqiBE4BFl-A8UVEhWdzEyfTOB9fLwOtFyzxqYnAdZhC_FglcImFJiTadJdqaBrZthtN16qAqVnAvhEZiUpny1Jj9aKE3aUAE28e9VbrIVX0o7ljn37uTMhGFXDv5tBcSUOJ_lf1IdP2rU6z-CNUEDZA6L6FSNwxjY2oLnnxGyjicncVkVg5Qoim6tMClMpP7nczESRK2LUi1nTPTPoDaKF4dqtOy3rEXqampQHzoRP0J4oajfeZyAfAugMRlL9XVnwye1sXWvDRg9NRK1kG5Gzk6qJECnvA9JvVfV4lcLzsW9wJYlOhxS7emUegBVNolLQc0yMxlx9PVC5NNMYqc0MAJ6C8RSdSdUEO8VElVIvk1-JFnyyukrCvxT_V9aJlemLGsv_Kcon-ruFU77A_uKaKJHXe0DY7EAdxQj7Mhs6jfDxUsPICummG8D4pn5p2PzIESDo4AVsa9ngU5VPAtCvOxMU8pG04iNlILiOyLB_7UoASeGlWvNp9py76-0iYqb7EPeJydjVc9R59RnBmP1NIO93sE26eLBeUUm4h_GF5noo5Fx2KoDRqcP3Fc-mKPWHCn9zcAg9kb1vrEW78tGmMMqmQj0qvYrVUXs2h80M9vNZbXWQ';
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
