import 'dart:io';

import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/api/interceptor/logger.dart';
import 'package:behandam/data/entity/regime/body_state.dart';
// import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../data/entity/auth/country_code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/sign_in.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
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

  NetworkResult<SignIn> signIn(User user);

  NetworkResult<VerificationCode> verificationCode(String mobile);

  NetworkResult<VerifyOutput> verify(VerificationCode verificationCode);

  NetworkResult<ResetOutput> reset(Reset password);

  NetworkResult<RegisterOutput> register(Register register);

  NetworkResult<FoodListData> foodList(String date, {bool invalidate = false});

  NetworkResult<RegimeType> regimeType();

  NetworkResult<Help> helpDietType(int id);

  NetworkResult<Help> helpBodyState(int id);

  NetworkResult<UserInformation> getUser();

  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

  NetworkResult<List<FastPatternData>> fastPattern({bool invalidate = false});

  NetworkResult<FastMenuRequestData> changeToFast(FastMenuRequestData requestData,
      {bool invalidate = false});

  NetworkResult<ListFoodData> listFood(String filter, {bool invalidate = false});

  NetworkResult<CityProvinceModel> getProvinces();

  NetworkResult<Media> sendMedia(String info, File media);

  NetworkResult<UserInformation> changeProfile(UserInformation userInformation);

  NetworkResult<Inbox> getUnreadInbox();

  NetworkResult<Inbox> getInbox();

  NetworkResult<TicketModel> getTickets();

  NetworkResult<SupportModel> getDepartmentItems();

  ImperativeNetworkResult sendTicketMessage(SendTicket sendTicket);

  ImperativeNetworkResult sendTicketFile(SendTicket sendTicket, File file);

  NetworkResult<TicketModel> getTicketDetails(int id);

  ImperativeNetworkResult sendTicketMessageDetail(SendTicket sendTicket);

  ImperativeNetworkResult sendTicketFileDetail(SendTicket sendTicket, File file);

  NetworkResult<bool> dailyMenu(DailyMenuRequestData requestData);
  NetworkResult getPath(RegimeType dietId);

  NetworkResult<BodyState> sendInfo(BodyState info);

  // NetworkResult<TicketModel> getTickets();
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

    _dio.interceptors.add(ErrorHandlerInterceptor());
    _dio.interceptors.add(GlobalInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio, baseUrl: FlavorConfig.instance.variables['baseUrl']);
    _cache = MemoryApp();
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
  NetworkResult<VerifyOutput> verify(VerificationCode verificationCode) async {
    var response = await _apiClient.verifyUser(verificationCode);
    return response;
  }

  @override
  NetworkResult<FoodListData> foodList(String date, {bool invalidate = false}) async {
    _cache.saveDate(date);
    NetworkResponse<FoodListData> response;
    debugPrint('repository1 ${_cache.date} / ${_cache.foodList} / $invalidate}');
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
  NetworkResult<SignIn> signIn(User user) async {
    var response = await _apiClient.signInWithPhoneNumber(user);
    return response;
  }

  @override
  NetworkResult<List<FastPatternData>> fastPattern({bool invalidate = false}) async {
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
  NetworkResult<FastMenuRequestData> changeToFast(FastMenuRequestData requestData,
      {bool invalidate = false}) async {
    requestData.date = _cache.date;
    // requestData.userId = _cache.profile?.userId;
    //ToDo fill it from cache
    requestData.userId = 63;
    if (requestData.patternId == null) requestData.patternId = 0;
    debugPrint('pattern request ${requestData.toJson()}');
    var response = await _apiClient.changeToFast(requestData);
    return response;
  }

  @override
  NetworkResult<ListFoodData> listFood(String filter, {bool invalidate = false}) async {
    var response = await _apiClient.listFood(filter);
    return response;
  }

  @override
  NetworkResult<RegimeType> regimeType() async {
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
  NetworkResult<bool> dailyMenu(DailyMenuRequestData requestData) async {
    var response = await _apiClient.dailyMenu(requestData);
    return response;
  }

  @override
  NetworkResult<SupportModel> getDepartmentItems() {
    var response = _apiClient.getDepartmentItems();
    return response;
  }

  @override
  ImperativeNetworkResult sendTicketMessage(SendTicket sendTicket) {
    sendTicket.hasAttachment = false;
    sendTicket.isVoice = false;
    var response = _apiClient.sendTicketMessage(sendTicket);
    return response;
  }

  @override
  ImperativeNetworkResult sendTicketFile(SendTicket sendTicket, File file) {
    sendTicket.hasAttachment = true;
    sendTicket.isVoice = true;
    var response = _apiClient.sendTicketFile(file, sendTicket.isVoice ? 1 : 0,
        sendTicket.hasAttachment ? 1 : 0, sendTicket.departmentId.toString(), sendTicket.title!);
    return response;
  }

  @override
  NetworkResult<TicketModel> getTicketDetails(int id) {
    var response = _apiClient.getTicketDetails(id);
    return response;
  }

  @override
  ImperativeNetworkResult sendTicketFileDetail(SendTicket sendTicket, File file) {
    var response = _apiClient.sendTicketFileDetail(
      media: file,
      is_voice: sendTicket.isVoice ? 1 : 0,
      has_attachment: sendTicket.hasAttachment ? 1 : 0,
      body: sendTicket.body,
      ticket_id: sendTicket.ticketId!,
    );
    return response;
  }

  @override
  ImperativeNetworkResult sendTicketMessageDetail(SendTicket sendTicket) {
    sendTicket.hasAttachment = false;
    sendTicket.isVoice = false;
    var response = _apiClient.sendTicketMessageDetail(sendTicket);
    return response;
  }

  @override
  NetworkResult<TicketModel> getTickets() {
    var response = _apiClient.getTicketMessage();
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
