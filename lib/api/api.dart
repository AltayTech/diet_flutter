import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';


import 'shared_prefrence.dart';
import '../base/network_response.dart';

import '../data/entity/auth/country-code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user-info.dart';
import '../data/entity/auth/verify.dart';
part 'api.g.dart';

typedef NetworkResult<T> = Future<NetworkResponse<T>>;
typedef ImperativeNetworkResult = NetworkResult<dynamic>;

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;
  // factory RestClient(Dio dio) = _RestClient;


  @GET("/countries")
  NetworkResult<List<Country>> getCountries();

  @GET("/check-user-status?mobile={mobile}")
  NetworkResult<CheckStatus> checkUserStatus(@Path('mobile') String? mobile);

  @POST("/send-verification-code")
  NetworkResult<VerificationCode> sendVerificationCode(@Body() User mobile);

  @PATCH("/verify")
  NetworkResult<VerifyOutput> verifyUser(@Body() VerificationCode code);

  @PATCH("/reset-password")
  NetworkResult<ResetOutput> resetPassword(@Body() Reset password);

  @POST("/register")
  NetworkResult<RegisterOutput> registerWithPhoneNumber(@Body() Register mobile);
}

// class RestApiClient {
//   static String? token = '';
//   static String? routeName;
//   static String? deviceName = "huawei";
//
//   RestApiClient() {
//     if (token == null) {
//       if (SharedPreference.pref != null) {
//         token = SharedPreference.pref?.getString(SharedP.token.toString())??'';
//       } else {
//         SharedPreference.iniSharedPreference();
//         try {
//           if (SharedPreference.pref != null) {
//             token = SharedPreference.pref?.getString(SharedP.token.toString())??'';
//           }
//         } on Exception catch (error) {
//           print("Exception $error");
//         }
//       }
//     }else{
//       print("token ==> " + token!);
//     }
//
//     Dio dio = Dio();
//     dio.options.headers = <String, String?>{
//       'Content-Type': 'application/json; charset=UTF-8',
//       'Authorization': 'Bearer $token',
//       'Accept-Language': 'fa',
//       'user_agent': 'behandam/$deviceName',
//       'X-Route': routeName ?? "null",
//     };
//
//     dio.interceptors.add(CustomInterceptors());
//     client = RestClient(dio, baseUrl: FlavorConfig.instance.variables["baseUrl"]);
//   }
//
//   RestClient? client;
// }
class CustomInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        "REQUEST[${options.data}] => PATH: ${FlavorConfig.instance.variables["baseUrl"]}${options.path}");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        "RESPONSE[${response.statusCode}] => PATH: ${FlavorConfig.instance.variables["baseUrl"]}${response.requestOptions.path}");
    print(
        "RESPONSE[${response.data}] => PATH: ${    FlavorConfig.instance.variables["baseUrl"]}${response.requestOptions.path}");
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

