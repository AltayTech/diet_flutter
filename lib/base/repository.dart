import 'dart:io';

import 'package:behandam/api/interceptor/error_handler.dart';
import 'package:behandam/api/interceptor/global.dart';
import 'package:behandam/api/interceptor/logger.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/fitamin.dart';
import 'package:behandam/data/entity/list_food/article.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/entity/payment/payment.dart';
import 'package:behandam/data/entity/poll_phrases/poll_phrases.dart';
import 'package:behandam/data/entity/psychology/booking.dart';
import 'package:behandam/data/entity/psychology/calender.dart';
import 'package:behandam/data/entity/psychology/reserved_meeting.dart';
import 'package:behandam/data/entity/refund.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/regime/body_status.dart' as body;
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/diet_preferences.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/data/entity/regime/obstructive_disease.dart';
import 'package:behandam/data/entity/regime/overview.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/data/entity/status/visit_item.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/data/entity/ticket/call_item.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/slider/slider.dart';

// import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/entity/user/version.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:dio/dio.dart';
import 'package:dio_http2_adapter/dio_http2_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:velocity_x/velocity_x.dart';

import '../api/api.dart';
import '../data/entity/auth/country.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/sign_in.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
import '../data/entity/auth/verify.dart';
import '../data/entity/user/block_user.dart';
import 'network_response.dart';

enum FoodDietPdf { TERM, WEEK }

abstract class Repository {
  static Repository? _instance;

  static void setInstanceNull() {
    _instance = null;
  }

  static Repository getInstance() {
    _instance ??= _RepositoryImpl();
    return _instance!;
  }

  NetworkResult<List<Country>?> country();

  NetworkResult<CheckStatus> status(String mobile);

  NetworkResult<SignIn> signIn(User user);

  NetworkResult<CheckStatus> verificationCode(String mobile, String channel);

  NetworkResult<VerifyOutput> otpLogin(VerificationCode verificationCode);

  NetworkResult<ResetOutput> reset(Reset password);

  NetworkResult<RegisterOutput> register(Register register);

  NetworkResult<FoodListData?> foodList(String date, {bool invalidate = false});

  NetworkResult<RegimeType> regimeType();

  NetworkResult<Help> helpDietType(int id);

  NetworkResult<Help> helpBodyState(int id);

  NetworkResult<UserInformation> getUser({bool invalidate = false});

  NetworkResult<Media> getPdfUrl(FoodDietPdf foodDietPdf);

  NetworkResult<List<FastPatternData>> fastPattern({bool invalidate = false});

  NetworkResult<FastMenuRequestData> changeToFast(FastMenuRequestData requestData,
      {bool invalidate = false});

  NetworkResult<ListFoodData> listFood(String filter, {bool invalidate = false});

  NetworkResult<CityProvinceModel> getProvinces();

  NetworkResult<Media> sendMedia(String info, File media);

  NetworkResult<UserInformation> changeProfile(UserInformationEdit userInformation);

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

  NetworkResult<CalendarData> calendar(String start, String end);

  NetworkResult<PhysicalInfoData> sendInfo(PhysicalInfoData info);

  NetworkResult<Call> getCalls();

  ImperativeNetworkResult sendRequestCall();

  ImperativeNetworkResult deleteRequestCall(int Id);

  NetworkResult<PollPhrases> getCallSurveyCauses();

  ImperativeNetworkResult sendCallRate(CallRateRequest callRateRequest);

  // NetworkResult<BodyStatus> getStatus(BodyStatus body);

  NetworkResult<CalenderOutput> getCalendar(String? startDate, String? endDate);

  NetworkResult<body.BodyStatus> getStatus();

  NetworkResult<PhysicalInfoData> physicalInfo();

  NetworkResult<UserSickness> getSickness();

  NetworkResult<ObstructiveDiseaseCategory> getNotBlockingSickness();

  ImperativeNetworkResult sendSickness(
      List<ObstructiveDiseaseCategory> diseasesIds, List<int> userObstructiveDiseaseSelected);

  NetworkResult<UserSicknessSpecial> getSicknessSpecial();

  ImperativeNetworkResult sendSicknessSpecial(UserSicknessSpecial sickness);

  NetworkResult<AdviceData> advice();

  NetworkResult<PackageItem> getPackagesList();

  NetworkResult setCondition(ConditionRequestData requestData);

  NetworkResult setUserReservePackage(ConditionRequestData requestData);

  NetworkResult<PackageItem> getPackagePayment();

  NetworkResult<PackageItem> getReservePackageUser();

  NetworkResult<Price?> checkCoupon(Price price);

  NetworkResult<Payment> setPaymentType(Payment payment);

  NetworkResult<Payment> setPaymentTypeReservePackage(Payment payment);

  ImperativeNetworkResult nextStep();

  NetworkResult<LatestInvoiceData> bankAccountActiveCard();

  NetworkResult<LatestInvoiceData> latestInvoice();

  NetworkResult<Payment> newPayment(Payment requestData);

  NetworkResult<BookingOutput> getBook(Booking booking);

  NetworkResult<HistoryOutput> getHistory();

  NetworkResult<LatestInvoiceData> getPsychologyInvoice();

  NetworkResult<DietPreferences> getDietPreferences();

  NetworkResult<ActivityLevelData> activityLevel();

  NetworkResult<DietHistoryData> dietHistory();

  NetworkResult<DietGoalData> dietGoals();

  NetworkResult<VisitItem> getVisits();

  NetworkResult<OverviewData> overview();

  NetworkResult<MenuData> menuType();

  NetworkResult<Term> term();

  NetworkResult<Fitamin> checkFitamin();

  NetworkResult<RegisterOutput> landingReg(Register register);

  NetworkResult<dynamic> visit(PhysicalInfoData requestData);

  ImperativeNetworkResult menuSelect(ConditionRequestData conditionRequestData);

  NetworkResult<Version> getVersion();

  NetworkResult<ShopModel> getHomeShop();

  NetworkResult<ShopCategory> getCategory(String id);

  NetworkResult<Orders> getOrders();

  NetworkResult<TermPackage> getTermPackage();

  NetworkResult<RefundItem> getRefund();

  ImperativeNetworkResult editVisit(PhysicalInfoData requestData);

  ImperativeNetworkResult verifyPassword(String pass);

  ImperativeNetworkResult setRefund(RefundVerify refundVerify);

  NetworkResult<ShopProduct> getProduct(int id);

  NetworkResult<Payment> shopOnlinePayment(Payment requestData);

  Future<Response> download(String pathFile, String pathDir);

  NetworkResult<LatestInvoiceData> shopLastInvoice();

  NetworkResult<ShopCategory> getProducts(String filter);

  NetworkResult<Price?> checkCouponShop(Price price);

  ImperativeNetworkResult seenInbox(int id);

  ImperativeNetworkResult addFcmToken(String token);

  ImperativeNetworkResult logout();

  NetworkResult<List<ArticleVideo>> getArticles(TimeRequest articleVideo);

  NetworkResult<TempTicket> getDailyMessage(int id);

  NetworkResult<TargetWeight> targetWeight();

  NetworkResult<ListUserSubscriptionData> getUserSubscription();

  NetworkResult<InboxItem> getInboxMessage(int id);

  NetworkResult<ObstructiveDiseaseCategory> getBlockingSickness();

  NetworkResult<DietType> getUserAllowedDietType();

  NetworkResult<Package> getPackages();

  NetworkResult<BlockUser> getBlockUserDescription();

  NetworkResult<Slider> getSliders();

  NetworkResult<SliderIntroduces> getSlidersIntroduces();
}

class _RepositoryImpl extends Repository {
  late Dio _dio;
  late RestClient _apiClient;
  late MemoryApp _cache;

  static const receiveTimeout = 15 * 1000;
  static const connectTimeout = 15 * 1000;
  static const sendTimeout = 15 * 1000;

  _RepositoryImpl() {
    _dio = Dio();
    _dio.options = BaseOptions(
      receiveTimeout: receiveTimeout,
      connectTimeout: connectTimeout,
      sendTimeout: sendTimeout,
    );
    if (!kIsWeb)
      _dio.httpClientAdapter = Http2Adapter(ConnectionManager(
        idleTimeout: 15 * 1000,
        // Ignore bad certificate
        onClientCreate: (_, config) => config.onBadCertificate = (_) => true,
      ));
    _dio.interceptors.add(ErrorHandlerInterceptor());
    _dio.interceptors.add(GlobalInterceptor());
    _dio.interceptors.add(LoggingInterceptor());
    _apiClient = RestClient(_dio, baseUrl: FlavorConfig.instance.variables['baseUrl']);
    _cache = MemoryApp();
  }

  @override
  NetworkResult<List<Country>?> country() async {
    MemoryApp.needRoute = false;
    var response;
    try {
      response = await _apiClient.getCountries();
      debugPrint('countries ${response.data?.length} / ${response.data?[0].name}');
      MemoryApp.needRoute = true;
    } catch (e) {
      debugPrint('countries error $e');
    }
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
  NetworkResult<CheckStatus> verificationCode(String mobile, String channel) async {
    var response = await _apiClient.sendVerificationCode(mobile, channel);
    return response;
  }

  @override
  NetworkResult<VerifyOutput> otpLogin(VerificationCode verificationCode) async {
    var response = await _apiClient.otpLogin(verificationCode);
    return response;
  }

  @override
  NetworkResult<FoodListData?> foodList(String date, {bool invalidate = false}) async {
    _cache.saveDate(date);
    NetworkResponse<FoodListData?> response;
    debugPrint('repository1 ${_cache.date} / ${_cache.foodList} / $invalidate}');
    if (_cache.date == null || _cache.foodList == null || invalidate) {
      response = await _apiClient.foodList(date);
      debugPrint('repository2 ${response.data}');
      if (invalidate && response.data != null) {
        _cache.saveNewFoodList(response.requireData!, date);
      } else {
        if (response.data != null) _cache.saveFoodList(response.requireData!, date);
      }
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
    requestData.userId = MemoryApp.userInformation?.userId ?? null;
    if (requestData.patternId == null) requestData.patternId = 0;
    debugPrint('pattern request ${requestData.toJson()}');
    var response = await _apiClient.changeToFast(requestData);
    return response;
  }

  @override
  NetworkResult<ListFoodData> listFood(String filter, {bool invalidate = false}) async {
    var response;
    try {
      response = await _apiClient.listFood(filter);
      debugPrint('list food }');
    } catch (e) {
      debugPrint('list food error $e');
    }
    return response;
  }

  @override
  NetworkResult<RegimeType> regimeType() async {
    var response = await _apiClient.getDietType();
    return response;
  }

  @override
  NetworkResult<Help> helpDietType(int id) async {
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
  NetworkResult<UserInformation> changeProfile(UserInformationEdit userInformation) {
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
  NetworkResult<CalendarData> calendar(String start, String end) async {
    var response;
    try {
      response = await _apiClient.calendar(start, end);
      debugPrint(
          'calendar repository ${response.requireData.terms[0].visits?.length} / ${response.requireData.terms[0].menus?.length}');
      return response;
    } catch (e) {
      debugPrint('error $e');
    }
    return response;
  }

  // @override
  // NetworkResult<TicketModel> getTickets() {
  //   var response = _apiClient.getTicketMessage();
  //   return response;
  // }
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
    var response = _apiClient.sendTicketFile(
        file,
        sendTicket.isVoice ? 1 : 0,
        sendTicket.hasAttachment ? 1 : 0,
        sendTicket.departmentId.toString(),
        sendTicket.body ?? '',
        sendTicket.title!);
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
  NetworkResult<PhysicalInfoData> sendInfo(PhysicalInfoData info) {
    var response = _apiClient.sendInfo(info);
    return response;
  }

  @override
  NetworkResult<Help> helpBodyState(int id) {
    var response = _apiClient.helpBodyState(id);
    return response;
  }

  @override
  NetworkResult<Call> getCalls() {
    var response = _apiClient.getCallItems();
    return response;
  }

  @override
  ImperativeNetworkResult sendRequestCall() {
    var response = _apiClient.sendCall();
    return response;
  }

  @override
  ImperativeNetworkResult deleteRequestCall(int Id) {
    var response = _apiClient.deleteCall(Id);
    return response;
  }

  @override
  NetworkResult<PollPhrases> getCallSurveyCauses() {
    var response = _apiClient.getCallSurveyCauses();
    return response;
  }

  @override
  ImperativeNetworkResult sendCallRate(CallRateRequest callRateRequest) {
    var response = _apiClient.sendCallRate(callRateRequest);
    return response;
  }

  @override
  NetworkResult<body.BodyStatus> getStatus() {
    var response = _apiClient.getStatus();
    return response;
  }

  @override
  NetworkResult<CalenderOutput> getCalendar(String? startDate, String? endDate) {
    var response = _apiClient.getCalendar(startDate, endDate);
    return response;
  }

  @override
  NetworkResult<PhysicalInfoData> physicalInfo() async {
    var response;
    try {
      response = _apiClient.physicalInfo();
      debugPrint('physical info ${response}');
    } catch (e) {
      debugPrint('physical info error $e');
    }
    return response;
  }

  @override
  NetworkResult<UserSickness> getSickness() {
    var response = _apiClient.getUserSickness();
    return response;
  }

  @override
  NetworkResult<ObstructiveDiseaseCategory> getNotBlockingSickness() {
    var response = _apiClient.getNotBlockingSickness();
    return response;
  }

  @override
  ImperativeNetworkResult sendSickness(
      List<ObstructiveDiseaseCategory> sickness, List<int> userObstructiveDiseaseSelected) {
    List<int> selectedItems = [];
    for (int i = 0; i < sickness.length; i++) {
      if (sickness[i].isSelected! && sickness[i].disease_id > 0) {
        selectedItems.add(sickness[i].disease_id);
      }
      for (int j = 0; j < sickness[i].diseases!.length; j++) {
        if (sickness[i].diseases![j].isSelected!) {
          selectedItems.add(sickness[i].diseases![j].id!);
        }
      }
    }
    // check if userObstructiveDiseaseSelected not contain in selectedItems then add to selectedItems
    if (userObstructiveDiseaseSelected.isNotEmpty) {
      for (int i = 0; i < userObstructiveDiseaseSelected.length; i++) {
        if (!selectedItems.contains(userObstructiveDiseaseSelected[i])) {
          selectedItems.add(userObstructiveDiseaseSelected[i]);
        }
      }
    }
    var response = _apiClient.setUserSickness({'disease_ids': selectedItems});
    return response;
  }

  @override
  NetworkResult<UserSicknessSpecial> getSicknessSpecial() {
    var response = _apiClient.getUserSicknessSpecial();
    return response;
  }

  @override
  ImperativeNetworkResult sendSicknessSpecial(UserSicknessSpecial sickness) {
    List<dynamic> selectedItems = [];
    UserSickness userSickness = new UserSickness();
    sickness.specials!.forEach((sicknessItem) {
      if (sicknessItem.isSelected!) {
        if (sicknessItem.children!.length > 0) {
          sicknessItem.children?.forEach((element) {
            debugPrint("${element.toJson()}");
          });
          Sickness sickness = Sickness();
          sickness.id = sicknessItem.children!.singleWhere((child) => child.isSelected!).id;
          selectedItems.add(sickness);
        } else {
          Sickness sickness = Sickness();
          sickness.id = sicknessItem.id;
          selectedItems.add(sickness);
          debugPrint("${sickness.toJson()}");
        }
      }
    });

    userSickness.specials = selectedItems;
    var response = _apiClient.setUserSicknessSpecial(userSickness);
    return response;
  }

  @override
  NetworkResult<AdviceData> advice() async {
    var response = await _apiClient.advice();
    debugPrint('advice repo ${response.data?.dietTypeRecommends?.length}');
    return response;
  }

  @override
  NetworkResult<PackageItem> getPackagesList() {
    var response = _apiClient.getPackages();
    return response;
  }

  @override
  NetworkResult setCondition(ConditionRequestData requestData) {
    Map<String, dynamic> body = {
      if (requestData.packageId != null) 'package_id': requestData.packageId,
      if (requestData.activityLevelId != null) 'activity_level_id': requestData.activityLevelId,
      if (requestData.dietHistoryId != null) 'diet_history_id': requestData.dietHistoryId,
      if (requestData.dietTypeId != null) 'diet_type_id': requestData.dietTypeId,
      if (requestData.dietGoalId != null) 'diet_goal_id': requestData.dietGoalId,
      if (requestData.isPreparedMenu != null) 'is_prepared_menu': requestData.isPreparedMenu,
      if (requestData.menuId != null) 'menu_id': requestData.menuId,
    };
    debugPrint('bloc condition2 $body');
    var response;
    try {
      response = _apiClient.setCondition(body);
      debugPrint('condition ${response.toString()}');
    } catch (e) {
      debugPrint('condition error ${e}');
    }
    return response;
  }

  @override
  NetworkResult setUserReservePackage(ConditionRequestData requestData) {
    Map<String, dynamic> body = {
      if (requestData.packageId != null) 'package_id': requestData.packageId,
      if (requestData.reservePackageId != null) 'reserve_package_id': requestData.reservePackageId,
      if (requestData.activityLevelId != null) 'activity_level_id': requestData.activityLevelId,
      if (requestData.dietHistoryId != null) 'diet_history_id': requestData.dietHistoryId,
      if (requestData.dietTypeId != null) 'diet_type_id': requestData.dietTypeId,
      if (requestData.dietGoalId != null) 'diet_goal_id': requestData.dietGoalId,
      if (requestData.isPreparedMenu != null) 'is_prepared_menu': requestData.isPreparedMenu,
      if (requestData.menuId != null) 'menu_id': requestData.menuId,
    };
    debugPrint('bloc condition2 $body');
    var response;
    try {
      response = _apiClient.setUserReservePackage(body);
      debugPrint('condition ${response.toString()}');
    } catch (e) {
      debugPrint('condition error ${e}');
    }
    return response;
  }

  @override
  NetworkResult<PackageItem> getPackagePayment() {
    var response = _apiClient.getPackageUser();
    return response;
  }

  @override
  NetworkResult<PackageItem> getReservePackageUser() {
    var response = _apiClient.getReservePackageUser();
    return response;
  }

  @override
  NetworkResult<Price?> checkCoupon(Price price) {
    var response = _apiClient.checkCoupon(price);
    return response;
  }

  @override
  NetworkResult<Payment> setPaymentType(Payment payment) {
    var response = _apiClient.selectPayment(payment);
    return response;
  }

  @override
  NetworkResult<Payment> setPaymentTypeReservePackage(Payment payment) {
    var response = _apiClient.selectPaymentReservePackage(payment);
    return response;
  }

  @override
  ImperativeNetworkResult nextStep() {
    var response = _apiClient.nextStep();
    return response;
  }

  @override
  NetworkResult<LatestInvoiceData> bankAccountActiveCard() {
    var response = _apiClient.bankAccountActiveCard();
    debugPrint('advice repo ${response}');
    return response;
  }

  @override
  NetworkResult<LatestInvoiceData> latestInvoice() {
    var response = _apiClient.latestInvoice();
    debugPrint('advice repo ${response}');
    return response;
  }

  @override
  NetworkResult<Payment> newPayment(Payment requestData) {
    var response = _apiClient.newPayment(requestData);
    return response;
  }

  @override
  NetworkResult<HistoryOutput> getHistory() {
    var response = _apiClient.getHistory();
    return response;
  }

  @override
  NetworkResult<BookingOutput> getBook(Booking booking) {
    var response = _apiClient.getBook(booking);
    return response;
  }

  @override
  NetworkResult<LatestInvoiceData> getPsychologyInvoice() {
    var response = _apiClient.getInvoice();
    return response;
  }

  @override
  NetworkResult<DietPreferences> getDietPreferences() {
    var response = _apiClient.getDietPreferences();
    return response;
  }

  @override
  NetworkResult<ActivityLevelData> activityLevel() {
    var response = _apiClient.activityLevel();
    return response;
  }

  @override
  NetworkResult<DietHistoryData> dietHistory() {
    var response = _apiClient.dietHistory();
    return response;
  }

  @override
  NetworkResult<DietGoalData> dietGoals() {
    var response = _apiClient.dietGoals();
    return response;
  }

  @override
  NetworkResult<VisitItem> getVisits() {
    var response = _apiClient.visits();
    return response;
  }

  @override
  NetworkResult<OverviewData> overview() {
    var response = _apiClient.overview();
    debugPrint('overview repo ${response}');
    return response;
  }

  @override
  NetworkResult<MenuData> menuType() {
    var response;
    try {
      response = _apiClient.menuType();
    } catch (e) {
      debugPrint('menutype error ${response}');
    }
    debugPrint('menutype repo ${response}');
    return response;
  }

  @override
  NetworkResult<Term> term() {
    var response = _apiClient.term();
    return response;
  }

  @override
  NetworkResult visit(PhysicalInfoData requestData) {
    var response = _apiClient.visit({
      'weight': requestData.weight,
      'height': requestData.height,
      'waist': requestData.waist,
      'birth_date': requestData.birthDate,
      // 'hip': requestData.hip,
      'multi_birth_num': requestData.multiBirth,
      'pregnancy_week_number': requestData.pregnancyWeek,
      'need_to_call': requestData.needToCall,
    });
    return response;
  }

  @override
  ImperativeNetworkResult menuSelect(ConditionRequestData conditionRequestData) {
    var response = _apiClient.menuSelect(conditionRequestData);
    return response;
  }

  @override
  NetworkResult<Version> getVersion() {
    var response = _apiClient.getVersion();
    return response;
  }

  @override
  NetworkResult<Fitamin> checkFitamin() {
    var response = _apiClient.checkFitamin();
    return response;
  }

  @override
  NetworkResult<RegisterOutput> landingReg(Register register) {
    var response = _apiClient.landingReg(register);
    return response;
  }

  @override
  NetworkResult<ShopModel> getHomeShop() {
    var response = _apiClient.getHomeShop();
    return response;
  }

  @override
  NetworkResult<ShopCategory> getCategory(String id) {
    var response = _apiClient.getCategory(id);
    return response;
  }

  @override
  NetworkResult<ShopProduct> getProduct(int id) {
    var response = _apiClient.getProduct(id);
    return response;
  }

  @override
  NetworkResult<Orders> getOrders() {
    var response = _apiClient.getOrders();
    return response;
  }

  @override
  NetworkResult<TermPackage> getTermPackage() {
    var response = _apiClient.getTermPackage();
    return response;
  }

  @override
  NetworkResult<RefundItem> getRefund() {
    var response = _apiClient.getRefund();
    return response;
  }

  @override
  ImperativeNetworkResult editVisit(PhysicalInfoData requestData) {
    var response = _apiClient.editVisit(requestData);
    return response;
  }

  @override
  ImperativeNetworkResult verifyPassword(String pass) {
    var response = _apiClient.verifyPassword(pass);
    return response;
  }

  @override
  ImperativeNetworkResult setRefund(RefundVerify refundVerify) {
    var response = _apiClient.setRefund(refundVerify);
    return response;
  }

  @override
  NetworkResult<Payment> shopOnlinePayment(Payment requestData) {
    var response = _apiClient.shopOnlinePayment(requestData);
    return response;
  }

  @override
  Future<Response> download(String urlPath, String pathDir) {
    var response = _dio.download(urlPath, pathDir);
    return response;
  }

  @override
  NetworkResult<LatestInvoiceData> shopLastInvoice() {
    var response = _apiClient.shopLastInvoice();
    return response;
  }

  @override
  NetworkResult<ShopCategory> getProducts(String filter) {
    var response = _apiClient.getProducts(filter);
    return response;
  }

  @override
  NetworkResult<Price?> checkCouponShop(Price price) {
    var response = _apiClient.checkCouponShop(price);
    return response;
  }

  @override
  ImperativeNetworkResult seenInbox(int id) {
    var response = _apiClient.getInboxItem(id);
    return response;
  }

  @override
  ImperativeNetworkResult addFcmToken(String token) {
    SignIn signIn = SignIn();
    signIn.token = token;
    var response = _apiClient.addFcmToken(signIn);
    return response;
  }

  @override
  ImperativeNetworkResult logout() {
    var response = _apiClient.logout();
    return response;
  }

  @override
  NetworkResult<List<ArticleVideo>> getArticles(TimeRequest articleVideo) async {
    NetworkResponse<List<ArticleVideo>> response;
    if (_cache.articles == null) {
      response = await _apiClient.getArticles(articleVideo);
      _cache.saveArticle(response.data ?? []);
    } else
      response = NetworkResponse.withData(_cache.articles);

    return response;
  }

  @override
  NetworkResult<TempTicket> getDailyMessage(int id) {
    var response = _apiClient.getDailyMessage(id);
    return response;
  }

  @override
  NetworkResult<TargetWeight> targetWeight() {
    var response = _apiClient.targetWeight();
    return response;
  }

  @override
  NetworkResult<ListUserSubscriptionData> getUserSubscription() {
    var response = _apiClient.getUserSubscription();
    return response;
  }

  @override
  NetworkResult<InboxItem> getInboxMessage(int id) {
    var response = _apiClient.getInboxMessage(id);
    return response;
  }

  @override
  NetworkResult<ObstructiveDiseaseCategory> getBlockingSickness() {
    var response = _apiClient.getBlockingSickness();
    return response;
  }

  @override
  NetworkResult<DietType> getUserAllowedDietType() {
    var response = _apiClient.getUserAllowedDietType();
    return response;
  }

  @override
  NetworkResult<Package> getPackages() {
    var response = _apiClient.getPackagesNew();
    return response;
  }

  @override
  NetworkResult<BlockUser> getBlockUserDescription() {
    var response = _apiClient.getBlockUserDescription();
    return response;
  }

  @override
  NetworkResult<Slider> getSliders() {
    var response = _apiClient.getSliders();
    return response;
  }

  @override
  NetworkResult<SliderIntroduces> getSlidersIntroduces() {
    var response = _apiClient.getSlidersIntroduces();
    return response;
  }
}
