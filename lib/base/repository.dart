import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
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
import '../data/entity/auth/sign-in.dart';


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

  NetworkResult<RegimeType> regimeType();

  NetworkResult<Help> helpDietType();

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
    _dio.interceptors.add(CustomInterceptors());
    _dio.interceptors.add(GlobalInterceptor());
    _dio.interceptors.add(ErrorHandlerInterceptor());
    _apiClient = RestClient(_dio,baseUrl: FlavorConfig.instance.variables['baseUrl']);
    // _cache = MemoryDataSource();
  }

  @override
  NetworkResult<List<CountryCode>> country() async{
    var response = await _apiClient.getCountries();
    return response;
  }

  @override
  NetworkResult<RegisterOutput> register(Register register) async{
    var response = await _apiClient.register(register);
    return response;
  }

  @override
  NetworkResult<ResetOutput> reset(Reset password) async{
    var response = await _apiClient.resetPassword(password);
    return response;
  }

  @override
  NetworkResult<CheckStatus> status(String mobile) async{
    var response = await _apiClient.checkUserStatus(mobile);
    return response;
  }

  @override
  NetworkResult<VerificationCode> verificationCode(String mobile) async{
    var response = await _apiClient.sendVerificationCode(mobile);
    return response;
  }

  @override
  NetworkResult<VerifyOutput> verify(String mobile, String code) async{
    var response = await _apiClient.verifyUser(mobile, code);
    return response;
  }

  @override
  NetworkResult<SignIn> signIn(String mobile, String pass) async{
    var response = await _apiClient.signInWithPhoneNumber(mobile, pass);
    return response;
  }

  @override
  NetworkResult<RegimeType> regimeType() async{
    var response = await _apiClient.getDietType();
    return response;
  }

  @override
  NetworkResult<Help> helpDietType() async{
    var response = await _apiClient.helpDietType();
    return response;
  }

}
