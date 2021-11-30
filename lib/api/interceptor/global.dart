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
      //debug
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZjFjYmQ5MTFlMDdiOTc5NWRhNTlmZWFhODU4NmMxMjZlYmUxZDM1OWNlNGI4ODQ1MGI5OWViMmVjYTMyNzhiNGU1MmQyN2RiN2VmMDE5Y2EiLCJpYXQiOjE2MzgxNzYzMzIuNTg1MTQsIm5iZiI6MTYzODE3NjMzMi41ODUxNDQsImV4cCI6MTY2OTcxMjMzMi41NzYwODYsInN1YiI6IjE2MDI5MTIiLCJzY29wZXMiOltdfQ.iQXELWncXaubIA6j9bVPklRGHAs_3Afdi_WNZ5grQYV_XplfRSSAUjE9FlHUT7uSmC7ruciF49VHNSLpqfg4W5TPii1j4zFWRbgKQ4OTxso2BpCteZ-A4FVhxQyLMzkE6KqnnSDXLx8u-fSK2lZzg7XoWCD3aSx4NJrL7FNi3_m_DPPgBeA8lhYD1RSfWocTdyX1Mxjk1Z0D3mGoWV-5OWpKqq04nfSKS1NvSY9sOxyTtzcL4huTt8BMppDZAne7OY0bK1wlD1O7nkaY79bcnQqLZg8Yy4_JBssX2mLRXrZ112WKass6LCDifNE6v484DNa9kmF8ZvcdXyndrWkljVCD4Y3Ep2ozC3bWOxAX1yr7e3bi2gxVLS3zTSlJaxoqB-m29O6uY0WPu2QNtHLZnzQsE7jHWwTWqt3YnJx65NtbELNLx-qn7gB51WmjQ_-kQmv5hDn4xEjDArgDMorb8XkgtSlw6kPiTiSgoqhgquGtgfndwsdGrqNRmN0S8aegTfT_rPMX6q5zyzdkJ0X9SXNAuleGPNFcBYnfOyHLj9o0gQr2AYevU3GvRVlJ4rJ87dr5HmHv6FiwxI7HudRPwiyCxBHyQWcWi5ZWtt3szqksR5ZeFRBzFiwWKYOPs3Kkk9AcHcNkegfTlyDF6lSnHPwPfAKuxQM88kdsLqlPA9M';
      //stage
      //   'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiOWQwZDAyMTQ5ZTQzYTVhZWY5MmUxMDAwZWFhOWMxODA2ZjFjY2QzNjQwNDFlZmJmNDE3N2M4ZjZkZmE5NTdjYTU2YjczYzQ0M2QyMDQwN2EiLCJpYXQiOjE2MzgxNjc0NjEuOTM1MTA4LCJuYmYiOjE2MzgxNjc0NjEuOTM1MTEzLCJleHAiOjE2Njk3MDM0NjEuOTIzMzgxLCJzdWIiOiIxMzUwNDA5Iiwic2NvcGVzIjpbXX0.GmLgGYoyGs2WGFQ57PF3QhEZEzKT-iJysSqASqN7tgII9_lrTPH8hJnM6CFkj367C4Gb4T-G-i3jiD0aDsLU6Q5a8KXZ3QgDrp25C7srjDDhx2gheuaOyVMW8hWWMFG0UqGGWeLEfBKEADycRRD45JxdRMYcry42PsuMXqWpKJrOYxM2MTalv9fAeArSA-2k_UmgTVTt5ICAIMP7Ira8hxFOT8fJN2lCNyWZQkeyCTvg1oQxo4uY_g8ntf5iwUipEHtiaDN__3GtfJke3UpUfz_0oRd8Nni32OCjYQwfLxYRK5Q_fdWeERLTo_ivdnyvwU0Gw2sIDYdLSPIKCA-7GdTrr9B8AvFdw6MXKZyOV0DPUujc_YfGHBrG7Bd8BTrt9UICFDZkG-MhlQuFZaPSmYiT1EsIWBQn-eI0iJU55w0QAh5PzQUHHLaRWblbQxVEPmq2QuL8VDGmRQOkJTltpWvYUkNlanzJeeKr2Wr3CsHY_ec-r4BUkfKX7ERusdKG_qOPOdIwmhVPAITQfE4ZARmrLKe_vK_dogKJGMQ-zG6n1j9hvDXIMc2WYIuUg6_ean-87ffBNi69OLk966-M0OpZEmgpt3DE-7xygTlxhNjVUCCpNrxGP_-g8-GkJG6PpjU0kKCvsfohU3SgUeOvoS5fSIBFm_kMjve3IM7fCp8';
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
