import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/filter/filter.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import '../api/api.dart';
import '../data/entity/auth/country-code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/sign-in.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/verify.dart';
import 'network_response.dart';

enum FoodDietPdf { TERM, WEEK }

abstract class Repository {
  static Repository? _instance;

  static Repository getInstance() {
    _instance ??= _RepositoryImpl();
    return _instance!;
  }

  NetworkResult<List<CountryCode>> country();

  NetworkResult<CheckStatus> status(String mobile);

  NetworkResult<SignIn> signIn(String mobile, String pass);

  NetworkResult<VerificationCode> verificationCode(String mobile);

  NetworkResult<VerifyOutput> verify(String mobile, String code);

  NetworkResult<ResetOutput> reset(Reset password);

  NetworkResult<RegisterOutput> register(Register register);

  NetworkResult<FoodListData> foodList(String date, {bool invalidate = false});

  NetworkResult<UserInformation> getUser();

  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

  NetworkResult<List<FastPatternData>> fastPattern({bool invalidate = false});

  NetworkResult<FastMenuRequestData> changeToFast(
      FastMenuRequestData requestData,
      {bool invalidate = false});

  NetworkResult<ListFoodData> listFood(
      String filter, {bool invalidate = false});
}

class _RepositoryImpl extends Repository {
  late Dio _dio;
  late RestClient _apiClient;
  late MemoryApp _cache;

  static const receiveTimeout = 5 * 60 * 1000;
  static const connectTimeout = 60 * 1000;
  static const sendTimeout = 5 * 60 * 1000;

  _RepositoryImpl() {
    _dio = Dio();
    _dio.options = BaseOptions(
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
    );
    // _dio.interceptors.add(CustomInterceptors());
    _dio.interceptors.add(ErrorHandlerInterceptor());
    _dio.interceptors.add(GlobalInterceptor());
    _apiClient =
        RestClient(_dio, baseUrl: FlavorConfig.instance.variables['baseUrl']);
    _cache = MemoryApp();
  }

  @override
  NetworkResult<List<CountryCode>> country() async {
    var response = await _apiClient.getCountries();
    return response;
  }

  @override
  NetworkResult<RegisterOutput> register(Register register) async {
    var response = await _apiClient.registerWithPhoneNumber(register);
    return response;
  }

  @override
  NetworkResult<ResetOutput> reset(Reset password) {
    var response = _apiClient.resetPassword(password);
    return response;
  }

  @override
  NetworkResult<CheckStatus> status(String mobile) async {
    var response = await _apiClient.checkUserStatus(mobile);
    return response;
  }

  @override
  NetworkResult<VerificationCode> verificationCode(String mobile) async {
    var response = await _apiClient.sendVerificationCode(mobile);
    return response;
  }

  @override
  NetworkResult<VerifyOutput> verify(String mobile, String code) async {
    var response = await _apiClient.verifyUser(mobile, code);
    return response;
  }

  @override
  NetworkResult<FoodListData> foodList(String date,
      {bool invalidate = false}) async {
    _cache.saveDate(date);
    NetworkResponse<FoodListData> response;
    debugPrint(
        'repository1 ${_cache.date} / ${_cache.foodList} / $invalidate}');
    if (_cache.date == null || _cache.foodList == null || invalidate) {
      response = await _apiClient.foodList(date);
      debugPrint('repository2 ${response.data}');
      _cache.saveFoodList(response.requireData, date);
      debugPrint('repository ${response.data}');
    } else {
      response = NetworkResponse.withData(_cache.foodList);
    }
    return response;
  }

  @override
  NetworkResult<UserInformation> getUser({bool invalidate = false}) async {
    NetworkResponse<UserInformation> response;
    if (_cache.profile == null || invalidate)
      response = await _apiClient.getProfile();
    else
      response = NetworkResponse.withData(_cache.profile);
    return response;
  }

  @override
  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf) {
    var response;
    switch (foodDietPdf) {
      case FoodDietPdf.TERM:
        response = _apiClient.getPdfTermUrl();
        break;
      case FoodDietPdf.WEEK:
        response = _apiClient.getPdfWeekUrl();
        break;
    }

    return response;
  }

  @override
  NetworkResult<SignIn> signIn(String mobile, String pass) async {
    var response = await _apiClient.signInWithPhoneNumber(mobile, pass);
    return response;
  }

  @override
  NetworkResult<List<FastPatternData>> fastPattern(
      {bool invalidate = false}) async {
    NetworkResponse<List<FastPatternData>> response;
    if (_cache.patterns == null || invalidate) {
      response = await _apiClient.fastPattern();
      _cache.savePatterns(response.requireData);
      debugPrint('pattern ${response.data?.length}');
    } else {
      response = NetworkResponse.withData(_cache.patterns);
    }
    return response;
  }

  @override
  NetworkResult<FastMenuRequestData> changeToFast(
      FastMenuRequestData requestData,
      {bool invalidate = false}) async {
    requestData.date = _cache.date;
    // requestData.userId = _cache.profile?.userId;
    //ToDo fill it from cache
    requestData.userId = 63;
    if (requestData.patternId == null) requestData.patternId = 0;
    debugPrint('pattern request ${requestData.toJson()}');
    var response =
        await _apiClient.changeToFast(requestData);
    return response;
  }

  @override
  NetworkResult<ListFoodData> listFood(String filter, {bool invalidate = false}) async{
    // '{"page":{"offset":0,"limit":30},"sort":[{"field":"title","dir":"asc"}],"filters":[[{"field":"title","op":"like","value":""}],[{"field":"meal_id","op":"=","value":1}]]}'
    var response =
        await _apiClient.listFood(filter);
    return response;
  }
}
