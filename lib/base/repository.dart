import 'dart:io';

import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/api/interceptor/logger.dart';
import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/data/entity/regime/body_state.dart';
// import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../data/entity/auth/country_code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
import '../data/entity/auth/verify.dart';
import '../data/entity/auth/sign_in.dart';

enum FoodDietPdf { TERM, WEEK }

abstract class Repository {
  static Repository? _instance;

  static Repository getInstance() {
    _instance ??= _RepositoryImpl();
    return _instance!;
  }

  NetworkResult<List<CountryCode>> country();

  NetworkResult<CheckStatus> status(String mobile);

  NetworkResult<SignIn> signIn(User user);

  NetworkResult<VerificationCode> verificationCode(String mobile);

  NetworkResult<VerifyOutput> verify(VerificationCode verificationCode);

  NetworkResult<ResetOutput> reset(Reset password);

  NetworkResult<RegisterOutput> register(Register register);

  NetworkResult<RegimeType> regimeType();

  NetworkResult<Help> helpDietType(int id);

  NetworkResult<Help> helpBodyState(int id);

  NetworkResult<FoodListData> foodList(String date);

  NetworkResult<UserInformation> getUser();

  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

  NetworkResult<CityProvinceModel> getProvinces();

  NetworkResult<Media> sendMedia(String info, File media);

  NetworkResult<UserInformation> changeProfile(UserInformation userInformation);

  NetworkResult<Inbox> getUnreadInbox();

  NetworkResult<Inbox> getInbox();

  NetworkResult getPath(RegimeType dietId);

  NetworkResult<BodyState> sendInfo(BodyState info);

  // NetworkResult<TicketModel> getTickets();
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

    _dio.interceptors.add(ErrorHandlerInterceptor());
    _dio.interceptors.add(GlobalInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio, baseUrl: FlavorConfig.instance.variables['baseUrl']);
    // _cache = MemoryDataSource();
  }

  @override
  NetworkResult<List<CountryCode>> country() async {
    var response = await _apiClient.getCountries();
    return response;
  }

  @override
  NetworkResult<RegisterOutput> register(Register register) async {
    var response = await _apiClient.register(register);
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
  NetworkResult<VerifyOutput> verify(VerificationCode verificationCode) async{
    var response = await _apiClient.verifyUser(verificationCode);
    return response;
  }

  @override
  NetworkResult<FoodListData> foodList(String date) async {
    var response = await _apiClient.foodList(date);
    return response;
  }

  @override
  NetworkResult<UserInformation> getUser() {
    var response = _apiClient.getProfile();
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
  NetworkResult<SignIn> signIn(User user) async {
    var response = await _apiClient.signInWithPhoneNumber(user);
    return response;
  }

  @override
  NetworkResult<RegimeType> regimeType() async{
    var response = await _apiClient.getDietType();
    return response;
  }

  @override
  NetworkResult<Help> helpDietType(int id) async{
    var response = await _apiClient.helpDietType(id);
    return response;
  }

  @override
  NetworkResult<CityProvinceModel> getProvinces() {
    var response = _apiClient.getProvinces();
    return response;
  }

  @override
  NetworkResult<Media> sendMedia(String info, File media) {
    var response = _apiClient.sendMedia(media, info);
    return response;
  }

  @override
  NetworkResult<UserInformation> changeProfile(UserInformation userInformation) {
    var response = _apiClient.updateProfile(userInformation);
    return response;
  }

  @override
  NetworkResult<Inbox> getUnreadInbox() {
    var response = _apiClient.getUnreadInbox();
    return response;
  }

  @override
  NetworkResult<Inbox> getInbox() {
    var response = _apiClient.getInbox();
    return response;
  }

  @override
  NetworkResult getPath(RegimeType dietId) {
    var response = _apiClient.getPath(dietId);
    return response;
  }

  @override
  NetworkResult<BodyState> sendInfo(BodyState info) {
    var response = _apiClient.sendInfo(info);
    return response;
  }

  @override
  NetworkResult<Help> helpBodyState(int id) {
    var response = _apiClient.helpBodyState(id);
    return response;
  }

  // @override
  // NetworkResult<TicketModel> getTickets() {
  //   var response = _apiClient.getTicketMessage();
  //   return response;
  // }
}
