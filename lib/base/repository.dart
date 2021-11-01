import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import '../base/network_response.dart';
import '../api/api.dart';
import '../data/entity/auth/country-code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user-info.dart';
import '../data/entity/auth/verify.dart';

enum FoodDietPdf{
  TERM,
  WEEK
}

abstract class Repository {
  static Repository? _instance;

  static Repository getInstance() {
    _instance ??= _RepositoryImpl();
    return _instance!;
  }

  NetworkResult<List<Country>> country();

  NetworkResult<CheckStatus> status(String mobile);

  NetworkResult<VerificationCode> verificationCode(User mobile);

  NetworkResult<VerifyOutput> verify(VerificationCode code);

  NetworkResult<ResetOutput> reset(Reset password);

  NetworkResult<RegisterOutput> register(Register mobile);

  NetworkResult<UserInformation> getUser();
  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

}

class _RepositoryImpl extends Repository {
  late Dio _dio;
  late RestClient _apiClient;
  // late MemoryDataSource _cache;

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
    _dio.interceptors.add(GlobalInterceptor());
    _dio.interceptors.add(CustomInterceptors());
     _dio.interceptors.add(ErrorHandlerInterceptor());
    _apiClient = RestClient(_dio,baseUrl: FlavorConfig.instance.variables['baseUrl']);
    // _cache = MemoryDataSource();
  }

  @override
  NetworkResult<List<Country>> country() async{
    var response = await _apiClient.getCountries();
    return response;
  }

  @override
  NetworkResult<RegisterOutput> register(Register mobile) async{
    var response = await _apiClient.registerWithPhoneNumber(mobile);
    return response;
  }

  @override
  NetworkResult<ResetOutput> reset(Reset password) {
    var response = _apiClient.resetPassword(password);
    return response;
  }

  @override
  NetworkResult<CheckStatus> status(String mobile) {
    var response =  _apiClient.checkUserStatus(mobile);
    print('response: $response');
    return response;
  }

  @override
  NetworkResult<VerificationCode> verificationCode(User mobile) {
    var response = _apiClient.sendVerificationCode(mobile);
    return response;
  }

  @override
  NetworkResult<VerifyOutput> verify(VerificationCode code){
    var response = _apiClient.verifyUser(code);
    return response;
  }

  @override
  NetworkResult<UserInformation> getUser() {
    var response =  _apiClient.getProfile();
    return response;
  }

  @override
  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf) {
    var response;
    switch(foodDietPdf) {
      case FoodDietPdf.TERM:
        response =  _apiClient.getPdfTermUrl();
        break;
      case FoodDietPdf.WEEK:
        response =  _apiClient.getPdfWeekUrl();
        break;
    }

    return response;
  }

}
