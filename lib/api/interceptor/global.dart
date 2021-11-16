import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/device.dart';
import 'package:dio/dio.dart';
import 'package:package_info_plus/package_info_plus.dart';

class GlobalInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // final authToken = await AppSharedPreferences.authToken;
    final packageInfo = await PackageInfo.fromPlatform();
    final languageCode = (await AppLocale.currentLocale).languageCode;
    // final fcmToken = await AppSharedPreferences.fcmToken;

    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = languageCode;
    options.headers['user-agent'] = DeviceUtils.makeUserAgent();
    options.headers['Charset'] = 'UTF-8';
    // if (authToken != 'null') {
    //   options.headers['authorization'] = 'Bearer ${MemoryApp.token}';
    // } else {
      final authToken = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDg2YTE1MTk0NmQ5NzIyZTYyM2E1NWEyNGNiNzRjMTAyMTQxMDQwZDZhMTQ5NWEwMTRiMTkzMjU0MTMyNTY4YjRkNWI4ZTU4NjM4YjViNzIiLCJpYXQiOjE2MzU2NTgzNjYuODk1NjI2LCJuYmYiOjE2MzU2NTgzNjYuODk1NjM1LCJleHAiOjE2NjcxOTQzNjYuODg1MDIyLCJzdWIiOiI2MyIsInNjb3BlcyI6W119.sUMtyZUiQBp6CIYmFYdY2avwjto1BxplgiyK1OPwQ4cqPFRzJHqjj679piWvrB3oD-ModWc62mDgf8WWlY6xstARIB_da2dxve5cSLzOVDA-Vzo3NWFgRdXjPhAcPFS7eo2ZQj2-kHTfIvsszFrS5_PauirXeUElVMd7UMjfdNmrbCkrMPjN2ao2v8xlMvK46hSwrELPPQ6PBJphYH2We1Wl62lIYZWJjycDSUnRcd4RXi0KGhzZurZmOCtk96c_HRAqrLWzUyzhKNYs_uiAWwfXWLkwbJg8UEzpZmPa8ai8dIQpK7gE6SrWas0A19t_cADxSQJMU5oXI9bQNkHO8_uRKW0DEq5wy0eRQTLr1l8i2WA_9EUAQI_TtIzUOwGHjwxEU8feA6vXbXlEJ8IdUvycVBE8g-t3qUmYibW2YSqX_xeHZaVBfLyN1lXH4vxNffEnGvQfdwb3iTiftf3xZIZqo4G2XGYOoCOiBnjl2g0CuMTjIgglr9rX90sgwtexQzxNTuEpAsahPaH5QG2qroaaoZL3Htb-niUJdp1JPhWPzeckwMq8uW4MCHEKzmdB4K17M9mWIr4TerlZl-SJOlN9WEAmpFVRE8WAEjfWxj1BzO4xl3lB6R6ysYfsCmR_cS2swAZi6VyX8HeSaDWq8-ui0hKMvI9inC5yJnwsMRM';
    //   final developToken = 'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMWJlMGQ2MmE5ZjBhNTI1ZmU1OGVlZTQ1MThjOTgxZDZmNzFhN2Q4YjVkNTFjODRkMjY1ZDRmMDQ2NDlmODNjNWQ0M2JiNzE5NjUwYmRkZjAiLCJpYXQiOjE2MzYxODczMjMuMDE3OTcyLCJuYmYiOjE2MzYxODczMjMuMDE3OTgsImV4cCI6MTY2NzcyMzMyMy4wMDY5NDQsInN1YiI6IjExMTExMjUiLCJzY29wZXMiOltdfQ.o6yCGqzdYUFrC3s_eJM0Tbn1lrnVKXTo6NhEtOOS8Vedn_cJfMazb44asQLKX83ICpBKr4-Rgz_Q4eD7vNTpkUSsbK3__XDGRkpA2_-UcJSslmCjZmdEqdG46CKjIoEmyADrKzzklGPMZM1MQ4wj7ZXmA7HAYAX7v9hyTZW48RRDmmv2Ka1e8oDrzuYjMZnpEI09nt_BZOmBYCkLTyXXHbpRDjofJ5GJyDCiZ3mbqsNDIT6BNx6pJFVn6urVtXrz0rgsS-WwW_gZTAOXQajpWmrfKdmwPTCCreWXPKzX-EvrD6DUfomSKtoQY2mla4BfiaTsdR-5CqMqbz_xY5j8UyIhvEAMUG-uq5uqVS4Dyl7BZbjTYpM6N1MDwFZtfD1q2hbPaQnRir9PKFH9Z36vH-ti3m9q3GVOr5LlYja8UB2n1LAFGiHd4s9RXHVKB82F7guetWxdgXE3fOvESTbBTzDwHHCqvVywAx9BUlYLKbv1hhNK6s0VJ6ek6nYBFz5PNMPq1W23MEHQmYq3zQegsACNg1AB_BpSYK0WgnOtWCJZ7JnsPw5dBVIH9mkXlUgVfhhYClKn2rMxF4PiXBK9s1xAjvOlpmM98vM0H5antzecHoYaCNEMtScUl5Zd7FdAoje7QrXp4IOcYW1BjVdGV-xlYCf7vOKdHphnfJj91PU';
      options.headers['authorization'] = authToken;
    // }
    // options.headers['Fcm-Token'] = fcmToken;
    options.headers['App'] = '0';
    options.headers['Application-Version-Code'] = packageInfo.buildNumber;
    options.headers['version'] = packageInfo.buildNumber;
    options.headers['Application-Version-Name'] = packageInfo.version;
    options.headers['Platform'] = DeviceUtils.platform;
    options.headers['Platform-Version'] = await DeviceUtils.platformVersion;
    options.headers['X-Device'] = await DeviceUtils.deviceName;
    options.headers['Device-Id'] = await DeviceUtils.deviceId;
    options.headers['Is-Emulator'] = await DeviceUtils.isEmulator;
    options.headers['Time-Zone'] = DateTimeUtils.timezoneOffset;
    options.headers['x-route'] = MemoryApp.routeName?.substring(1, MemoryApp.routeName?.length);
    super.onRequest(options, handler);
  }
}
