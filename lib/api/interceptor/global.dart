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
    if (authToken != null) {
      options.headers['authorization'] = 'Bearer ${authToken}';
    }
    // else {
    //   options.headers['authorization'] =
    //       'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiNzg0ZTE0YzFiYzY0MzE1YzU0ZjdlMGEzNTYzODhhZTAzMjk5MmM1ODcwMWU3MTdhNWI3NGZjNDNmMmJiMjExZTE2MWYwNzUxOGM4MmQzZDUiLCJpYXQiOjE2MzgwODYwNjcuOTY4ODU4LCJuYmYiOjE2MzgwODYwNjcuOTY4ODYzLCJleHAiOjE2Njk2MjIwNjcuOTY0MzUzLCJzdWIiOiI4MzU4ODciLCJzY29wZXMiOltdfQ.KVQ369ho-n2-LfjQbGhW3PXe0r-lMU8YrvpBUK5v7an80iXv64YrFlSK3GfXQ98enwI_Co04FZ7zeQ7_WJr31HRvc3wx50iIJVZnvUfxohLLNJsZwdsabSxpSknCCD22U-4Bm5Fgr6icdS5Y1rsc_utU4gLrsB7NQ_v9xITJBwHoZ3X0wpdHeD8wtP84vgopv1OFU4EQWlaPGh1Q6sumsjnrsWEMGKf1nMMckHv6Z3J4ENlaK_Eie_D0GEa3Isw9QU2j_Cvm1F_BpaLaLcNQEX-uqU4NqJJ6q62w5lVgtLvKCEme0Cdx8w5w5P0S_BfY5m1uuIxpV2Mqj20sD9ArdRZeNKAOJ5bEIYjADgalIo8ASuSMKyhg2UJyTNPwL92wn7Ck2GkacfWIgzG4On0eJGJe9677IHnyoAqGi7j3K0dQGjs5NHgMAmlOu2HV6E1ovLda-M7BXMo6Uue97B0zJuDRWKPPFJ3GZ9fgICGfpaHuc56wDtIgXtYm7KcFll1PdmiAgNMbMlHFiMnIb8U6BkSSjocbl-d7Pnst5B7Arl_NsnC_n2n8xCSfYODY0nnywQyk_NCf6Vi56DruEQsA0A5U2pNoqcfn5TMGixNo2EQbCBjaIbDjoUhKIfjDqNI0l6xsiqKUuHb_ytdl_2ahWMeFRwcyk1dI_zUJDsu_dhM';
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
