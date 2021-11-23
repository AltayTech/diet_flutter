import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/authentication/code_reset.dart';
import 'package:behandam/screens/authentication/pass_reset.dart';
import 'package:behandam/screens/authentication/register.dart';
import 'package:behandam/screens/authentication/verify.dart';
import 'package:behandam/screens/calendar/calendar.dart';
import 'package:behandam/screens/daily_menu/daily_menu.dart';
import 'package:behandam/screens/daily_menu/list_food.dart';
import 'package:behandam/screens/fast/fast_pattern.dart';
import 'package:behandam/screens/advice/advice.dart';
import 'package:behandam/screens/food_list/change_meal_food.dart';
import 'package:behandam/screens/food_list/food_list.dart';
import 'package:behandam/screens/payment/debit_card.dart';
import 'package:behandam/screens/profile/edit_profile.dart';
import 'package:behandam/screens/profile/inbox_list.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/screens/profile/show_item_inbox.dart';
import 'package:behandam/screens/regime/body-status.dart';
import 'package:behandam/screens/regime/help_type.dart';
import 'package:behandam/screens/regime/package/package_list.dart';
import 'package:behandam/screens/regime/payment/payment_bill.dart';
import 'package:behandam/screens/regime/regime_type.dart';
import 'package:behandam/screens/regime/sickness/sickness.dart';
import 'package:behandam/screens/regime/sickness/sickness_special.dart';
import 'package:behandam/screens/regime/state_of_body.dart';
import 'package:behandam/screens/ticket/new_ticket.dart';
import 'package:behandam/screens/ticket/ticketTabs.dart';
import 'package:behandam/screens/ticket/ticket_details.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/shapes.dart';
import 'package:behandam/themes/typography.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/authentication/login.dart';
import '../screens/authentication/pass.dart';

class App extends StatefulWidget {
  @override
  State createState() => _AppState();
}

class _AppState extends State<App> {
  late AppBloc bloc;
  late String token;

  @override
  void initState() {
    super.initState();
    bloc = AppBloc();
    getToken();
    AppColors(themeAppColor: ThemeAppColor.DEFAULT);
    navigator.addListener(() {
      print('routeName is => ${navigator.currentConfiguration!.path}');
    });
  }

  getToken() async {
    MemoryApp.token = await AppSharedPreferences.authToken;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return app();
      },
    );
  }

  Widget app() {
    return AppProvider(
      bloc,
      child: StreamBuilder(
        stream: bloc.locale,
        builder: (context, AsyncSnapshot<Locale> snapshot) {
          final locale = snapshot.data ?? appInitialLocale;
          return MaterialApp.router(
              useInheritedMediaQuery: true,
              // generate title from localization instead of `MaterialApp.title` property
              onGenerateTitle: (BuildContext context) => context.intl.appName,
              debugShowCheckedModeBanner: false,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocale.supportedLocales,
              theme: ThemeData(
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.primary,
                    onPrimary: AppColors.onPrimary,
                    onSurface: AppColors.onSurface,
                    shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.borderRadiusMedium),
                  ),
                ),
                primaryColor: AppColors.primary,
                primaryColorDark: AppColors.primaryColorDark,
                scaffoldBackgroundColor: AppColors.scaffold,
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
              // navigatorObservers: [routeObserver],
              // initialRoute: (MemoryApp.token!='null' && MemoryApp.token!.isNotEmpty) ? Routes.home : Routes.auth,
              // routes: Routes.all,

              routeInformationParser: VxInformationParser(),
              backButtonDispatcher: RootBackButtonDispatcher(),
              routerDelegate: navigator);
        },
      ),
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

final navigator = VxNavigator(
  routes: {
    '/': (_, __) => MaterialPage(child: DebitCardPage()),
    Routes.editProfile: (_, __) => MaterialPage(child: EditProfileScreen()),
    Routes.profile: (_, __) => MaterialPage(child: ProfileScreen()),
    Routes.login: (_, __) => MaterialPage(child: LoginScreen()),
    Routes.pass: (_, param) => MaterialPage(child: PasswordScreen(), arguments: param),
    Routes.verify: (_, param) => MaterialPage(child: VerifyScreen(), arguments: param),
    Routes.register: (_, param) => MaterialPage(child: RegisterScreen(), arguments: param),
    Routes.listView: (_, __) => MaterialPage(child: FoodListPage()),
    Routes.dailyMenu: (_, param) => MaterialPage(child: DailyMenuPage(), arguments: param),
    Routes.fastPatterns: (_, __) => MaterialPage(child: FastPatternPage()),
    Routes.listFood: (_, param) => MaterialPage(child: ListFoodPage(), arguments: param),
    Routes.inbox: (_, __) => MaterialPage(child: InboxList()),
    Routes.showInbox: (_, param) => MaterialPage(child: ShowInboxItem(), arguments: param),
    Routes.ticketMessage: (_, param) => MaterialPage(child: TicketTab(), name: 'message'),
    Routes.ticketCall: (_, param) => VxRoutePage(child: TicketTab(), pageName: 'call'),
    Routes.resetCode: (_, param) => MaterialPage(child: CodeResetScreen(), arguments: param),
    Routes.resetPass: (_, param) => MaterialPage(child: PasswordResetScreen(), arguments: param),
    Routes.helpType: (_, __) => MaterialPage(child: HelpTypeScreen()),
    Routes.newTicketMessage: (_, __) => MaterialPage(child: NewTicket()),
    RegExp(r"\/ticket\/details"): (uri, __) => MaterialPage(
        child: TicketDetails(), arguments: int.parse(uri.queryParameters['ticketId'].toString())),
    Routes.replaceFood: (_, param) => MaterialPage(child: ChangeMealFoodPage(), arguments: param),
    Routes.calendar: (_, __) => MaterialPage(child: CalendarPage()),
    Routes.regimeType: (_, __) => MaterialPage(child: RegimeTypeScreen()),
    Routes.bodyState: (_, param) => MaterialPage(child: BodyStateScreen(), arguments: param),
    Routes.bodyStatus: (_, __) => MaterialPage(child: BodyStatusScreen()),
    Routes.sickness: (_, __) => MaterialPage(child: SicknessScreen()),
    Routes.special_sickness: (_, __) => MaterialPage(child: SicknessSpecialScreen()),
    Routes.advice: (_, __) => MaterialPage(child: AdvicePage()),
    Routes.package: (_, __) => MaterialPage(child: PackageListScreen()),
    Routes.paymentBill: (_, __) => MaterialPage(child: PaymentBillScreen()),
    Routes.cardToCard: (_, __) => MaterialPage(child: DebitCardPage()),
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
