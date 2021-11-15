import 'dart:io';

import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/data/entity/food_list/food_list.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:dio/dio.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import '../api/api.dart';
import '../data/entity/auth/country_code.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/sign_in.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
import '../data/entity/auth/verify.dart';

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

  NetworkResult<Help> helpDietType();

  NetworkResult<FoodListData> foodList(String date);

  NetworkResult<UserInformation> getUser();

  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

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
    _dio.interceptors.add(ErrorHandlerInterceptor());
    _dio.interceptors.add(GlobalInterceptor());
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
  NetworkResult<VerifyOutput> verify(VerificationCode verificationCode) async {
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
  NetworkResult<RegimeType> regimeType() async {
    var response = await _apiClient.getDietType();
    return response;
  }

  @override
  NetworkResult<Help> helpDietType() async {
    var response = await _apiClient.helpDietType();
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
  NetworkResult<TicketModel> getTickets() {
    var response = _apiClient.getTicketMessage();
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
}
