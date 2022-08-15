import 'dart:io';

import 'package:behandam/data/entity/fitamin.dart';
import 'package:behandam/data/entity/list_food/article.dart';
import 'package:behandam/data/entity/refund.dart';
import 'package:behandam/data/entity/regime/activity_level.dart';
import 'package:behandam/data/entity/advice/advice.dart';
import 'package:behandam/data/entity/auth/country.dart';
import 'package:behandam/data/entity/auth/sign_in.dart';
import 'package:behandam/data/entity/calendar/calendar.dart';
import 'package:behandam/data/entity/fast/fast.dart';
import 'package:behandam/data/entity/list_food/daily_menu.dart';
import 'package:behandam/data/entity/list_food/list_food.dart';
import 'package:behandam/data/entity/list_view/food_list.dart';
import 'package:behandam/data/entity/psychology/booking.dart';
import 'package:behandam/data/entity/psychology/calender.dart';
import 'package:behandam/data/entity/payment/latest_invoice.dart';
import 'package:behandam/data/entity/psychology/reserved_meeting.dart';
import 'package:behandam/data/entity/regime/condition.dart';
import 'package:behandam/data/entity/regime/diet_goal.dart';
import 'package:behandam/data/entity/regime/diet_history.dart';
import 'package:behandam/data/entity/regime/menu.dart';
import 'package:behandam/data/entity/regime/overview.dart';
import 'package:behandam/data/entity/regime/physical_info.dart';
import 'package:behandam/data/entity/regime/body_status.dart';
import 'package:behandam/data/entity/regime/help.dart';
import 'package:behandam/data/entity/regime/package_list.dart';
import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/regime/target_weight.dart';
import 'package:behandam/data/entity/regime/user_sickness.dart';
import 'package:behandam/data/entity/regime/sickness.dart' as sickness;
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/data/entity/status/visit_item.dart';
import 'package:behandam/data/entity/subscription/user_subscription.dart';
import 'package:behandam/data/entity/ticket/call_item.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/data/entity/user/city_provice_model.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/data/entity/user/user_information.dart';
import 'package:behandam/data/entity/user/version.dart';
import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:retrofit/retrofit.dart';

import '../base/network_response.dart';
import '../data/entity/auth/register.dart';
import '../data/entity/auth/reset.dart';
import '../data/entity/auth/status.dart';
import '../data/entity/auth/user_info.dart';
import '../data/entity/auth/verify.dart';
import '../data/entity/payment/payment.dart';
part 'api.g.dart';

/*enum help {
  @JsonValue(1)
  dietType
}*/

typedef NetworkResult<T> = Future<NetworkResponse<T>>;
typedef ImperativeNetworkResult = NetworkResult<dynamic>;

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @GET("/country")
  NetworkResult<List<Country>> getCountries();

  @GET("/check-user-status?mobile={mobile}")
  NetworkResult<CheckStatus> checkUserStatus(@Path('mobile') String? mobile);

  @POST("/login")
  NetworkResult<SignIn> signInWithPhoneNumber(@Body() User user);

  @POST("/send-verification-code?mobile={mobile}&channel={channel}")
  NetworkResult<CheckStatus> sendVerificationCode(@Path('mobile') String? mobile,@Path('channel') String? channel);

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
  NetworkResult<dynamic> setCondition(@Body() Map<String, dynamic> requestData);

  @PATCH("/user/reserve-package")
  NetworkResult<dynamic> setUserReservePackage(@Body() Map<String, dynamic> requestData);

  @PATCH("/physical-info")
  NetworkResult<PhysicalInfoData> sendInfo(@Body() PhysicalInfoData info);

  @GET("/body-status")
  NetworkResult<BodyStatus> getStatus();

  @GET("/user/menu?date={date}")
  NetworkResult<FoodListData> foodList(@Path() String date);

  @GET("/profile")
  NetworkResult<UserInformation> getProfile();

  @GET("/user/menu/all/pdf")
  NetworkResult<Media> getPdfTermUrl();

  @GET("/user/menu/pdf")
  NetworkResult<Media> getPdfWeekUrl();

  @GET("/province")
  NetworkResult<CityProvinceModel> getProvinces();

  @POST("/media")
  NetworkResult<Media> sendMedia(@Part(name: "media") File media, @Part(name: "info") String info);

  @PATCH("/profile")
  NetworkResult<UserInformation> updateProfile(@Body() UserInformationEdit userInformation);

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

  @GET("/calendar?start_date={start}&end_date={end}")
  NetworkResult<CalendarData> calendar(@Path() String start, @Path() String end);

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
      @Part(name: "body") String body,
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

  @GET("/calls")
  NetworkResult<Call> getCallItems();

  @POST("/calls")
  ImperativeNetworkResult sendCall();

  @DELETE("/calls/{id}")
  ImperativeNetworkResult deleteCall(@Path('id') int id);

  @GET("/psychology/v2/dates/list?start_date={startDate}&end_date={endDate}")
  NetworkResult<CalenderOutput> getCalendar(@Path() String? startDate, @Path() String? endDate);

  @GET("/physical-info")
  NetworkResult<PhysicalInfoData> physicalInfo();

  @GET("/user-sickness")
  NetworkResult<UserSickness> getUserSickness();

  @GET("/not-blocking-sicknesses")
  NetworkResult<List<sickness.Sickness>> getNotBlockingSickness();

  @PATCH("/user-sickness")
  ImperativeNetworkResult setUserSickness(@Body() UserSickness userSickness);

  @GET("/user-special")
  NetworkResult<UserSicknessSpecial> getUserSicknessSpecial();

  @PATCH("/user-special")
  ImperativeNetworkResult setUserSicknessSpecial(@Body() UserSickness userSickness);

  @GET("/user-recommend")
  NetworkResult<AdviceData> advice();

  @GET("/package")
  NetworkResult<PackageItem> getPackages();

  @GET("/user/package")
  NetworkResult<PackageItem> getPackageUser();

  @GET("/user/reserve-package")
  NetworkResult<PackageItem> getReservePackageUser();

  @POST("/check-coupon")
  NetworkResult<Price?> checkCoupon(@Body() Price price);

  @POST("/payment")
  NetworkResult<Payment> selectPayment(@Body() Payment payment);

  @POST("/user/reserve-package")
  NetworkResult<Payment> selectPaymentReservePackage(@Body() Payment payment);

  @GET("/next-step")
  ImperativeNetworkResult nextStep();

  @GET("/bank-account/active-card")
  NetworkResult<LatestInvoiceData> bankAccountActiveCard();

  @GET("/latest-invoice")
  NetworkResult<LatestInvoiceData> latestInvoice();

  @POST("/user/payment/card2card")
  NetworkResult<Payment> newPayment(@Body() Payment requestData);

  @POST("/psychology/v2/booking")
  NetworkResult<BookingOutput> getBook(@Body() Booking booking);

  @GET("/psychology/v2/booking-histories")
  NetworkResult<HistoryOutput> getHistory();

  @GET("/psychology/latest-invoice")
  NetworkResult<LatestInvoiceData> getInvoice();

  @GET("/activity-level")
  NetworkResult<ActivityLevelData> activityLevel();

  @GET("/diet-history")
  NetworkResult<DietHistoryData> dietHistory();

  @GET("/diet-goal")
  NetworkResult<DietGoalData> dietGoals();

  @GET("/user/condition")
  NetworkResult<OverviewData> overview();

  @GET("/user/visits")
  NetworkResult<VisitItem> visits();

  @GET("/menu-type?is_user=1")
  NetworkResult<MenuData> menuType();

  @PATCH("/term")
  NetworkResult<Term> term();

  @POST("/menu-select")
  ImperativeNetworkResult menuSelect(@Body() ConditionRequestData conditionRequestData);

  @POST("/visit")
  NetworkResult<dynamic> visit(@Body() Map<String, dynamic> requestData);

  @GET("/check-version")
  NetworkResult<Version> getVersion();


  @GET("/fitamin-url")
  NetworkResult<Fitamin> checkFitamin();

  @GET("/register")
  NetworkResult<RegisterOutput> landingReg(@Body() Register reg);

  @GET("/homepage")
  NetworkResult<ShopModel> getHomeShop();

  @GET("/categories/{id}")
  NetworkResult<ShopCategory> getCategory(@Path('id') String id);

  // @GET("/categories/{id}?filter={filter}")
  // NetworkResult<ShopCategory> getProductCategory(@Path('filter') String filter);

  @GET("/orders")
  NetworkResult<Orders> getOrders();

  @GET("/products/{id}")
  NetworkResult<ShopProduct> getProduct(@Path('id') int id);

  @GET("/user/term-package")
  NetworkResult<TermPackage> getTermPackage();

  @GET("/refund")
  NetworkResult<RefundItem> getRefund();

  @PATCH("/visit")
  ImperativeNetworkResult editVisit(@Body() PhysicalInfoData requestData);

  @GET("/auth?password={password}")
  ImperativeNetworkResult verifyPassword(@Path('password') String? mobile);

  @POST("/refund")
  ImperativeNetworkResult setRefund(@Body() RefundVerify refundVerify);

  @POST("/payment-shop")
  NetworkResult<Payment> shopOnlinePayment(@Body() Payment requestData);

  @GET("/latest-shop-invoice")
  NetworkResult<LatestInvoiceData> shopLastInvoice();

  @GET("/products?filter={filter}")
  NetworkResult<ShopCategory> getProducts(@Path('filter') String filter);

  @POST("/check-coupon-shop")
  NetworkResult<Price?> checkCouponShop(@Body() Price price);

  @GET("/inbox/{id}")
  NetworkResult<Inbox> getInboxItem(@Path('id') int id);

  @POST("/firebase-token")
  ImperativeNetworkResult addFcmToken(@Body() SignIn signIn);

  @GET("/logout")
  ImperativeNetworkResult logout();

  @GET("/user/date/articles")
  NetworkResult<List<ArticleVideo>> getArticles(@Queries(encoded: false) TimeRequest articleVideo);

  @GET("/template/{id}?need-log=1")
  NetworkResult<TempTicket> getDailyMessage(@Path('id') int id);

  @GET("/target-weight")
  NetworkResult<TargetWeight> targetWeight();

  @GET("/user/subscription/history")
  NetworkResult<ListUserSubscriptionData> getUserSubscription();

  @GET("/inbox/{id}")
  NetworkResult<InboxItem> getInboxMessage(@Path('id') int id);
}

