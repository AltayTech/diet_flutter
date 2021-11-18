
import 'dart:io';

import 'package:behandam/data/entity/auth/country_code.dart';
import 'package:behandam/data/entity/auth/sign_in.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/regime/body_state.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:retrofit/retrofit.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:dio/dio.dart';

import '../base/network_response.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
import '../data/entity/auth/verify.dart';

part 'api.g.dart';

enum help {
  @JsonValue(1)
  dietType
}

typedef NetworkResult<T> = Future<NetworkResponse<T>>;
typedef ImperativeNetworkResult = NetworkResult<dynamic>;

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;


  @GET("/country")
  NetworkResult<List<CountryCode>> getCountries();

  @GET("/check-user-status?mobile={mobile}")
  NetworkResult<CheckStatus> checkUserStatus(@Path('mobile') String? mobile);

  @POST("/login")
  NetworkResult<SignIn> signInWithPhoneNumber(@Body() User user);

  @POST("/send-verification-code?mobile={mobile}")
  NetworkResult<VerificationCode> sendVerificationCode(@Path('mobile') String? mobile);

  @GET("/verify")
  NetworkResult<VerifyOutput> verifyUser(@Queries() VerificationCode verificationCode);

  @PATCH("/reset-password")
  NetworkResult<ResetOutput> resetPassword(@Body() Reset password);

  @POST("/register")
  NetworkResult<RegisterOutput> register(@Body() Register reg);

  @GET("/diet-type")
  NetworkResult<RegimeType> getDietType();

  @GET("/page/{id}")
  NetworkResult<Help> helpDietType(@Path('id') int id);

  @GET("/field/{id}")
  NetworkResult<Help> helpBodyState(@Path('id') int id);

  @PATCH("/condition")
  NetworkResult getPath(@Body() RegimeType id);

  @PATCH("/physical-info")
  NetworkResult<BodyState> sendInfo(@Body() BodyState info);

  @GET("/body-status")
  NetworkResult<BodyStatus> getStatus(@Body() BodyStatus body);


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

  @POST("/media")
  NetworkResult<Media> sendMedia(@Part(name: "media") File media, @Part(name: "info") String info);

  @PATCH("/profile")
  NetworkResult<UserInformation> updateProfile(@Body() UserInformation userInformation);

  @GET("/inbox/unseen/count")
  NetworkResult<Inbox> getUnreadInbox();

  @GET("/inbox")
  NetworkResult<Inbox> getInbox();

  @GET("/ticket")
  NetworkResult<TicketModel> getTicketMessage();
  
  @GET("/fasting-pattern")
  NetworkResult<List<FastPatternData>> fastPattern();

  @POST("/user-fasting-log")
  NetworkResult<FastMenuRequestData> changeToFast(@Body() FastMenuRequestData requestData);

  @GET("/food?filter={filter}")
  NetworkResult<ListFoodData> listFood(@Path('filter') String filter);

  @POST("/user/menu")
  NetworkResult<bool> dailyMenu(@Body() DailyMenuRequestData date);
  @GET("/department")
  NetworkResult<SupportModel> getDepartmentItems();

  @POST("/ticket")
  ImperativeNetworkResult sendTicketMessage(@Body() SendTicket sendTicket);

  @POST("/message")
  ImperativeNetworkResult sendTicketMessageDetail(@Body() SendTicket sendTicket);

  @POST("/ticket")
  ImperativeNetworkResult sendTicketFile(
      @Part(name: "media") File media,
      @Part(name: "is_voice") int is_voice,
      @Part(name: "has_attachment") int has_attachment,
      @Part(name: "department_id") String department_id,
      @Part(name: "title") String title);

  @POST("/message")
  ImperativeNetworkResult sendTicketFileDetail(
      {@Part(name: "media") File? media,
      @Part(name: "is_voice") int? is_voice,
      @Part(name: "ticket_id") int? ticket_id,
      @Part(name: "body") String? body,
      @Part(name: "has_attachment") int? has_attachment});

  @GET("/ticket/{id}")
  NetworkResult<TicketModel> getTicketDetails(@Path('id') int id);
}

class CustomInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options,
      RequestInterceptorHandler handler) async {
    print(
        "REQUEST[${options.data}] => PATH: ${FlavorConfig.instance
            .variables["baseUrl"]}${options.path}");
    print('HEADERS:');
    options.headers.forEach((key, v) => print(' - $key ==> $v'));
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        "RESPONSE[${response.statusCode}] => PATH: ${FlavorConfig.instance
            .variables["baseUrl"]}${response.requestOptions.path}");
    print(
        "RESPONSE[${response.data}] => PATH: ${FlavorConfig.instance
            .variables["baseUrl"]}${response.requestOptions.path}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("ERROR[$err] => PATH:");
    print("ERROR[${err.response?.statusCode}] => PATH:");
    print(
        "ERROR[${err.response?.statusCode}] => PATH: ${err.response
            ?.statusMessage} => DATA: PATH: ${err.response?.data}");
    super.onError(err, handler);
  }
}

