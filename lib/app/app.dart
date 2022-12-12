import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/base/utils.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/advice/advice.dart';
import 'package:behandam/screens/authentication/pass_reset.dart';
import 'package:behandam/screens/authentication/register.dart';
import 'package:behandam/screens/authentication/verify.dart';
import 'package:behandam/screens/calendar/calendar.dart';
import 'package:behandam/screens/daily_menu/daily_menu.dart';
import 'package:behandam/screens/daily_menu/list_food.dart';
import 'package:behandam/screens/fast/fast_pattern.dart';
import 'package:behandam/screens/food_list/alert_list.dart';
import 'package:behandam/screens/food_list/change_meal_food.dart';
import 'package:behandam/screens/food_list/food_list.dart';
import 'package:behandam/screens/payment/bill.dart';
import 'package:behandam/screens/payment/debit_card.dart';
import 'package:behandam/screens/payment/fail.dart';
import 'package:behandam/screens/payment/success.dart';
import 'package:behandam/screens/payment/wait.dart';
import 'package:behandam/screens/profile/edit_profile.dart';
import 'package:behandam/screens/profile/inbox_list.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/screens/profile/reset_pass.dart';
import 'package:behandam/screens/profile/show_item_inbox.dart';
import 'package:behandam/screens/psychology/calender.dart';
import 'package:behandam/screens/psychology/intro.dart';
import 'package:behandam/screens/psychology/payment_bill.dart';
import 'package:behandam/screens/psychology/reserved_meeting.dart';
import 'package:behandam/screens/psychology/terms.dart';
import 'package:behandam/screens/refund/refund.dart';
import 'package:behandam/screens/refund/refund_record.dart';
import 'package:behandam/screens/refund/refund_verify.dart';
import 'package:behandam/screens/regime/activity/activity_level.dart';
import 'package:behandam/screens/regime/block/block.dart';
import 'package:behandam/screens/regime/body-status.dart';
import 'package:behandam/screens/regime/diet_hostory/diet_history.dart';
import 'package:behandam/screens/regime/goal/diet_goal.dart';
import 'package:behandam/screens/regime/help_type.dart';
import 'package:behandam/screens/regime/menu/menu_confirm.dart';
import 'package:behandam/screens/regime/menu/menu_select.dart';
import 'package:behandam/screens/regime/overview/overview.dart';
import 'package:behandam/screens/regime/package/package_list.dart';
import 'package:behandam/screens/regime/regime_type.dart';
import 'package:behandam/screens/regime/sickness/sickness.dart';
import 'package:behandam/screens/regime/sickness/sickness_special.dart';
import 'package:behandam/screens/regime/state_of_body.dart';
import 'package:behandam/screens/shop/category_page.dart';
import 'package:behandam/screens/shop/home/shop_home.dart';
import 'package:behandam/screens/shop/orders.dart';
import 'package:behandam/screens/shop/payment/bill.dart';
import 'package:behandam/screens/shop/product_page.dart';
import 'package:behandam/screens/splash/splash.dart';
import 'package:behandam/screens/status/status_user.dart';
import 'package:behandam/screens/ticket/new_ticket.dart';
import 'package:behandam/screens/ticket/support.dart';
import 'package:behandam/screens/ticket/ticketTabs.dart';
import 'package:behandam/screens/ticket/ticket_details.dart';
import 'package:behandam/screens/vitrin/vitrin.dart';
import 'package:behandam/screens/widget/empty_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/themes/typography.dart';
import 'package:behandam/widget/sizer/sizer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_frame/flutter_web_frame.dart';

import 'package:velocity_x/velocity_x.dart';

import '../screens/authentication/auth.dart';
import '../screens/authentication/login.dart';

class App extends StatefulWidget {
  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  late AppBloc bloc;
  late String token;
  static late double webMaxWidth = 500;
  static late double webMinRatio = 1 / 2; // minimum aspect ratio for application size
  static late double webMaxHeight = 700;
  @override
  void initState() {
    super.initState();
    bloc = AppBloc();
    bloc.changeTheme(ThemeAppColor.BLUE);
    setTokenToMemoryApp();

    navigator.addListener(() {
      print('routeName is => ${navigator.currentConfiguration!.path}');
     /* if (MemoryApp.analytics != null)
        MemoryApp.analytics!
            .logEvent(name: navigator.currentConfiguration!.path.replaceAll("/", "_").substring(1));*/
    });
  }

  void setTokenToMemoryApp() async {
    MemoryApp.token = await AppSharedPreferences.authToken;
    debugPrint('init token ${MemoryApp.token}');
  }


  @override
  Widget build(BuildContext context) {
    //cache one of vitrin's image for reduce time of loading
    precacheImage(const AssetImage("assets/images/vitrin/bmi_banner.jpg"), context);
    return Sizer(
      maxWidth: kIsWeb ? webMaxWidth : null,
      minRatio: kIsWeb ? webMinRatio : null,
      builder: (context, orientation, deviceType, constraints) {
        return appProvider(constraints);
      },
    );
  }

  Widget appProvider(BoxConstraints constraints) {
    return AppProvider(
      bloc,
      child: StreamBuilder(
        stream: bloc.locale,
        builder: (context, AsyncSnapshot<Locale> snapshot) {
          final locale = snapshot.data ?? appInitialLocale;
          return kIsWeb ? webFrame(locale, constraints) : app(locale);
        },
      ),
    );
  }

  Widget app(Locale locale) {
    return MaterialApp.router(
        builder: (BuildContext context, Widget? child) {
          // don't scale font when accessibility setting of device is changing font size
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: child ?? EmptyBox());
        },
        useInheritedMediaQuery: true,
        // generate title from localization instead of `MaterialApp.title` property
        onGenerateTitle: (BuildContext context) => context.intl.appName,
        debugShowCheckedModeBanner: false,
        color: AppColors.background,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocale.supportedLocales,
        theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.onPrimary,
              backgroundColor: AppColors.primary,
              disabledForegroundColor: AppColors.onSurface.withOpacity(0.38),
              disabledBackgroundColor: AppColors.onSurface.withOpacity(0.12),
              shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.borderRadiusMedium),
            ),
          ),
          primaryColor: AppColors.primary,
          primaryColorDark: AppColors.primaryColorDark,
          scaffoldBackgroundColor: AppColors.scaffold,
          snackBarTheme: SnackBarThemeData(
              contentTextStyle: AppTypography(locale).caption.copyWith(
                color: Colors.white,
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.black54,
              elevation: 0,
              shape: AppShapes.rectangleDefault),
          textTheme: buildTextTheme(locale),
          appBarTheme: AppBarTheme(
            backgroundColor: AppColors.primary,
          ),
          colorScheme: ColorScheme.fromSwatch(primarySwatch: AppMaterialColors.primary)
              .copyWith(secondary: AppColors.primary),
        ),
        locale: locale,
        localeResolutionCallback: resolveLocale,
        scaffoldMessengerKey: navigatorMessengerKey,
        //navigatorObservers: [routeObserver],
        // initialRoute: (MemoryApp.token!='null' && MemoryApp.token!.isNotEmpty) ? Routes.home : Routes.auth,
        // routes: Routes.all,
        routeInformationParser: VxInformationParser(),
        backButtonDispatcher: RootBackButtonDispatcher(),
        routerDelegate: navigator);
  }

  Widget webFrame(Locale locale, BoxConstraints constraints) {
    return FlutterWebFrame(
      builder: (context) => app(locale),
      maximumSize: Size(
        constraints.maxWidth < webMaxWidth ? constraints.maxWidth : webMaxWidth,
        webMaxHeight,
      ),
      enabled: kIsWeb,
      backgroundColor: AppColors.primary.withOpacity(0.1),
    );
  }

  TextTheme buildTextTheme(Locale locale) {
    final appTypography = AppTypography(locale);
    return TextTheme(
      headline1: appTypography.headline1,
      headline2: appTypography.headline2,
      headline3: appTypography.headline3,
      headline4: appTypography.headline4,
      headline5: appTypography.headline5,
      headline6: appTypography.headline6,
      bodyText1: appTypography.bodyText1,
      bodyText2: appTypography.bodyText2,
      caption: appTypography.caption,
      overline: appTypography.overline,
      subtitle1: appTypography.subtitle1,
      subtitle2: appTypography.subtitle2,
      button: appTypography.button,
    );
  }

  /// resolve locale when device locale is changed
  Locale resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    for (var supportedLocale in supportedLocales) {
      final isLanguageEqual = supportedLocale.languageCode == locale?.languageCode;
      final isCountryCodeEqual = supportedLocale.countryCode == locale?.countryCode;
      if (isLanguageEqual && isCountryCodeEqual) {
        return supportedLocale;
      }
    }
    return appInitialLocale;
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }
}

class MyObs extends VxObserver {
  @override
  void didChangeRoute(Uri route, Page page, String pushOrPop) {
    print("${route.path} - $pushOrPop");
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    print('Pushed a route');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    print('Popped a route');
  }
}

final navigator = VxNavigator(
  routes: {
    Routes.splash: (_, __) => MaterialPage(child: routePage(SplashScreen())),
    Routes.editProfile: (_, __) => MaterialPage(child: routePage(EditProfileScreen())),
    Routes.profile: (_, __) => MaterialPage(child: routePage(ProfileScreen())),
    Routes.auth: (_, __) => MaterialPage(child: routePage(AuthScreen())),
    Routes.login: (_, param) => MaterialPage(child: routePage(LoginScreen()), arguments: param),
    Routes.authVerify: (_, param) =>
        MaterialPage(child: routePage(VerifyScreen()), arguments: param),
    Routes.passVerify: (_, param) =>
        MaterialPage(child: routePage(VerifyScreen()), arguments: param),
    Routes.resetPass: (_, param) =>
        MaterialPage(child: routePage(PasswordResetScreen()), arguments: param),
    Routes.resetCode: (_, param) =>
        MaterialPage(child: routePage(ResetPasswordProfile()), arguments: param),
    Routes.register: (_, param) =>
        MaterialPage(child: routePage(RegisterScreen()), arguments: param),
    Routes.listView: (_, __) => MaterialPage(child: routePage(FoodListPage())),
    Routes.dailyMenu: (_, param) =>
        MaterialPage(child: routePage(DailyMenuPage()), arguments: param),
    Routes.fastPatterns: (_, __) => MaterialPage(child: routePage(FastPatternPage())),
    Routes.listFood: (_, param) => MaterialPage(child: routePage(ListFoodPage()), arguments: param),
    Routes.inbox: (_, __) => MaterialPage(child: routePage(InboxList())),
    Routes.showInbox: (_, param) =>
        MaterialPage(child: routePage(ShowInboxItem()), arguments: param),
    Routes.ticketMessage: (_, param) =>
        MaterialPage(child: routePage(Support()), name: 'message'),
    Routes.ticketCall: (_, param) => VxRoutePage(child: routePage(TicketTab()), pageName: 'call'),
    Routes.helpType: (_, param) =>
        MaterialPage(child: routePage(HelpTypeScreen()), arguments: param),
    Routes.newTicketMessage: (_, __) => MaterialPage(child: routePage(NewTicket())),
    RegExp(r"\/ticket\/details"): (uri, __) => MaterialPage(
        child: routePage(TicketDetails()),
        arguments: int.parse(uri.queryParameters['ticketId'].toString())),
    Routes.replaceFood: (_, param) =>
        MaterialPage(child: routePage(ChangeMealFoodPage()), arguments: param),
    Routes.calendar: (_, __) => MaterialPage(child: routePage(CalendarPage())),
    RegExp(r"\/(reg|renew|revive)(\/diet\/type)"): (_, __) =>
        MaterialPage(child: routePage(RegimeTypeScreen())),
    RegExp(r"\/(reg|renew|revive)(\/size)"): (_, __) =>
        MaterialPage(child: routePage(BodyStateScreen())),
    RegExp(r"\/(reg|renew|revive)(\/report)"): (_, __) =>
        MaterialPage(child: routePage(BodyStatusScreen())),
    RegExp(r"\/(reg|renew|list|revive)(\/sick\/select)"): (_, __) =>
        MaterialPage(child: routePage(SicknessScreen())),
    RegExp(r"\/(reg|renew|list|revive)(\/special)"): (_, __) =>
        MaterialPage(child: routePage(SicknessSpecialScreen())),
    Routes.advice: (_, __) => MaterialPage(child: routePage(AdvicePage())),
    RegExp(r"\/(reg|renew|revive)(\/package)"): (_, __) =>
        MaterialPage(child: routePage(PackageListScreen())),
    RegExp(r"\/(reg|renew|revive)(\/payment\/bill)"): (_, __) =>
        MaterialPage(child: routePage(PaymentBillScreen())),
    RegExp(r"\/(reg|renew|revive)(\/payment\/card\/confirm)"): (_, __) =>
        MaterialPage(child: routePage(PaymentSuccessScreen())),
    RegExp(r"\/(reg|renew|revive)(\/payment\/card)"): (_, __) =>
        MaterialPage(child: routePage(DebitCardPage())),
    Routes.vitrin: (_, __) => MaterialPage(child: routePage(VitrinScreen())),
    Routes.psychologyIntro: (_, __) => MaterialPage(child: routePage(PsychologyIntroScreen())),
    Routes.psychologyCalender: (_, params) =>
        MaterialPage(child: routePage(PsychologyCalenderScreen()), arguments: params),
    Routes.psychologyTerms: (_, params) =>
        MaterialPage(child: routePage(PsychologyTermsScreen()), arguments: params),
    Routes.psychologyPaymentBill: (_, params) =>
        MaterialPage(child: routePage(PsychologyPaymentBillScreen()), arguments: params),
    Routes.psychologyReservedMeeting: (_, __) =>
        MaterialPage(child: routePage(PsychologyReservedMeetingScreen())),
    Routes.resetPasswordProfile: (_, __) => MaterialPage(child: routePage(ResetPasswordProfile())),
    RegExp(r"\/(reg|list|renew|revive)(\/payment\/online\/fail)"): (_, params) =>
        MaterialPage(child: routePage(PaymentFailScreen()), arguments: params),
    RegExp(r"\/(reg|list|renew|revive)(\/payment\/card\/reject)"): (_, __) =>
        MaterialPage(child: routePage(PaymentFailScreen())),
    RegExp(r"\/(reg|renew|revive)(\/activity)"): (_, __) =>
        MaterialPage(child: routePage(ActivityLevelPage())),
    RegExp(r"\/(reg|list|renew|revive)(\/payment\/card\/wait)"): (_, __) =>
        MaterialPage(child: routePage(PaymentWaitScreen())),
    Routes.dietHistory: (_, __) => MaterialPage(child: routePage(DietHistoryPage())),
    Routes.dietGoal: (_, __) => MaterialPage(child: routePage(DietGoalPage())),
    Routes.overview: (_, __) => MaterialPage(child: routePage(OverviewPage())),
    RegExp(r"\/(reg|list|renew|revive)(\/menu\/select)"): (_, __) =>
        MaterialPage(child: routePage(MenuSelectPage())),
    RegExp(r"\/(reg|list|renew|revive)(\/menu\/confirm)"): (_, param) =>
        MaterialPage(child: routePage(MenuConfirmPage()), arguments: param),
    Routes.statusUser: (_, __) => MaterialPage(child: routePage(StatusUserScreen())),
    RegExp(r"\/(reg|list)(\/weight\/enter)"): (_, __) =>
        MaterialPage(child: routePage(BodyStateScreen())),
    RegExp(r"\/(reg|renew|revive)(\/weight)"): (_, __) =>
        MaterialPage(child: routePage(BodyStateScreen())),
    Routes.listMenuAlert: (_, __) => MaterialPage(child: routePage(AlertFlowPage())),
    Routes.listWeightAlert: (_, __) => MaterialPage(child: routePage(AlertFlowPage())),
    Routes.renewAlert: (_, __) => MaterialPage(child: routePage(AlertFlowPage())),
    Routes.reviveAlert: (_, __) => MaterialPage(child: routePage(AlertFlowPage())),
    RegExp(r"\/(reg|list|renew|revive|shop)(\/payment\/online\/success)"): (_, param) =>
        MaterialPage(child: routePage(PaymentSuccessScreen()), arguments: param),
    RegExp(r"\/(reg|list|renew|revive)(\/sick\/block)"): (_, __) =>
        MaterialPage(child: routePage(Block())),
    RegExp(r"\/(reg|list|renew|revive)(\/block)"): (_, __) =>
        MaterialPage(child: routePage(Block())),
    Routes.shopCategory: (_, param) =>
        MaterialPage(child: routePage(CategoryPage()), arguments: param),
    Routes.shopOrders: (_, __) => MaterialPage(child: routePage(OrdersPage())),
    Routes.shopHome: (_, __) => MaterialPage(child: routePage(ShopHomeScreen())),
    Routes.refund: (_, __) => MaterialPage(child: routePage(RefundScreen())),
    Routes.refundVerify: (_, __) => MaterialPage(child: routePage(RefundVerifyScreen())),
    Routes.refundRecord: (_, __) => MaterialPage(child: routePage(RefundRecordScreen())),
    RegExp(r"\/shop\/product\/[0-9]+"): (uri, __) =>
        MaterialPage(child: routePage(ProductPage()), arguments: uri.pathSegments[2]),
    Routes.shopBill: (_, param) => MaterialPage(child: routePage(ShopBillPage()), arguments: param),
    RegExp(r"\/shop\/categories\/[0-9]+"): (uri, __) =>
        MaterialPage(child: routePage(CategoryPage()), arguments: uri.pathSegments[2]),
  },
  notFoundPage: (uri, params) => MaterialPage(
    key: ValueKey('not-found-page'),
    child: Builder(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('Page ${uri.path} not found'),
        ),
      ),
    ),
  ),
);
DateTime? currentBackPressTime;

Widget routePage(Widget page) => Builder(
      builder: (context) {
        return (Navigator.canPop(context))
            ? page
            : WillPopScope(
                child: page,
                onWillPop: () {
                  DateTime now = DateTime.now();
                  if (currentBackPressTime == null ||
                      now.difference(currentBackPressTime!) > Duration(seconds: 4)) {
                    currentBackPressTime = now;
                    Utils.getSnackbarMessage(context, context.intl.exitAppAlert);
                    return Future.value(false);
                  }
                  return Future.value(true);
                },
              );
      },
    );
