import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:retrofit/retrofit.dart';

import '../base/network_response.dart';
import '../data/entity/auth/country-code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/sign-in.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/verify.dart';

part 'api.g.dart';

typedef NetworkResult<T> = Future<NetworkResponse<T>>;
typedef ImperativeNetworkResult = NetworkResult<dynamic>;

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  // factory RestClient(Dio dio) = _RestClient;

  @GET("/country")
  NetworkResult<List<CountryCode>> getCountries();

  @GET("/check-user-status?mobile={mobile}")
  NetworkResult<CheckStatus> checkUserStatus(@Path('mobile') String? mobile);

  @POST("/login?mobile={mobile}&password={pass}")
  NetworkResult<SignIn> signInWithPhoneNumber(
      @Path('mobile') String? mobile, @Path('pass') String? pass);

  @POST("/send-verification-code?mobile={mobile}")
  NetworkResult<VerificationCode> sendVerificationCode(@Path('mobile') String? mobile);

  @GET("/verify?mobile={mobile}&verification_code={code}")
  NetworkResult<VerifyOutput> verifyUser(
      @Path('mobile') String? mobile, @Path('code') String? code);

  @PATCH("/reset-password")
  NetworkResult<ResetOutput> resetPassword(@Body() Reset password);

  @POST("/register")
  NetworkResult<RegisterOutput> registerWithPhoneNumber(@Body() Register mobile);

  @GET("/user/menu?date={date}")
  NetworkResult<FoodListData> foodList(@Path() String date);

  @GET("/profile")
  NetworkResult<UserInformation> getProfile();

  @GET("/user/menu/all/pdf")
  NetworkResult<UserInformation> getPdfTermUrl();

  @GET("/user/menu/pdf")
  NetworkResult<UserInformation> getPdfWeekUrl();

  @GET("/province")
  NetworkResult<CityProvinceModel> getProvinces();
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async{
    /*   final languageCode = (await AppLocale.currentLocale).languageCode;

  options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    options.headers['Accept-Language'] = languageCode.capitalize();
    options.headers['Charset'] = 'UTF-8';
    // final authToken = await AppSharedPreferences.authToken;
    final authToken = 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiZDg2YTE1MTk0NmQ5NzIyZTYyM2E1NWEyNGNiNzRjMTAyMTQxMDQwZDZhMTQ5NWEwMTRiMTkzMjU0MTMyNTY4YjRkNWI4ZTU4NjM4YjViNzIiLCJpYXQiOjE2MzU2NTgzNjYuODk1NjI2LCJuYmYiOjE2MzU2NTgzNjYuODk1NjM1LCJleHAiOjE2NjcxOTQzNjYuODg1MDIyLCJzdWIiOiI2MyIsInNjb3BlcyI6W119.sUMtyZUiQBp6CIYmFYdY2avwjto1BxplgiyK1OPwQ4cqPFRzJHqjj679piWvrB3oD-ModWc62mDgf8WWlY6xstARIB_da2dxve5cSLzOVDA-Vzo3NWFgRdXjPhAcPFS7eo2ZQj2-kHTfIvsszFrS5_PauirXeUElVMd7UMjfdNmrbCkrMPjN2ao2v8xlMvK46hSwrELPPQ6PBJphYH2We1Wl62lIYZWJjycDSUnRcd4RXi0KGhzZurZmOCtk96c_HRAqrLWzUyzhKNYs_uiAWwfXWLkwbJg8UEzpZmPa8ai8dIQpK7gE6SrWas0A19t_cADxSQJMU5oXI9bQNkHO8_uRKW0DEq5wy0eRQTLr1l8i2WA_9EUAQI_TtIzUOwGHjwxEU8feA6vXbXlEJ8IdUvycVBE8g-t3qUmYibW2YSqX_xeHZaVBfLyN1lXH4vxNffEnGvQfdwb3iTiftf3xZIZqo4G2XGYOoCOiBnjl2g0CuMTjIgglr9rX90sgwtexQzxNTuEpAsahPaH5QG2qroaaoZL3Htb-niUJdp1JPhWPzeckwMq8uW4MCHEKzmdB4K17M9mWIr4TerlZl-SJOlN9WEAmpFVRE8WAEjfWxj1BzO4xl3lB6R6ysYfsCmR_cS2swAZi6VyX8HeSaDWq8-ui0hKMvI9inC5yJnwsMRM';
    if (authToken != null) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }*/
    print(
        "REQUEST[${options.data}] => PATH: ${FlavorConfig.instance.variables["baseUrl"]}${options.path}");
    print('HEADERS:');
    options.headers.forEach((key, v) => print(' - $key ==> $v'));
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        "RESPONSE[${response.statusCode}] => PATH: ${FlavorConfig.instance.variables["baseUrl"]}${response.requestOptions.path}");
    print(
        "RESPONSE[${response.data}] => PATH: ${FlavorConfig.instance.variables["baseUrl"]}${response.requestOptions.path}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("ERROR[$err] => PATH:");
    print("ERROR[${err.response?.statusCode}] => PATH:");
    print(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.response?.statusMessage} => DATA: PATH: ${err.response?.data}");
    super.onError(err, handler);
  }
}
