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
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
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
    print("ERROR[${err.response?.statusCode}] => PATH:");
    print(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.response?.statusMessage} => DATA: PATH: ${err.response?.data}");
    super.onError(err, handler);
  }
}
