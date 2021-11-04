import 'package:behandam/app/bloc.dart';
import 'package:behandam/app/provider.dart';
import 'package:behandam/data/entity/auth/register.dart';
import 'package:behandam/data/memory_cache.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/extensions/build_context.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/food_list/food_list.dart';

import 'package:behandam/screens/lgn_reg/register.dart';
import 'package:behandam/screens/lgn_reg/verify.dart';
import 'package:behandam/screens/profile/edit_profile.dart';
import 'package:behandam/screens/profile/profile.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/themes/typography.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sizer/sizer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../screens/lgn_reg/login.dart';
import '../screens/lgn_reg/pass.dart';

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
  }

  getToken() async {
    MemoryApp.token = await AppSharedPreferences.authToken;
  }

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return  DevicePreview(
         // enabled: !kReleaseMode,
          enabled: false,
          builder: (context) => app(), // Wrap your app
        );
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
                primaryColor: AppColors.primary,
                  primaryColorDark: AppColors.primaryColorDark,
                  scaffoldBackgroundColor: AppColors.scaffold,
                  textTheme: buildTextTheme(locale),
                  appBarTheme: AppBarTheme(
                    backgroundColor: AppColors.primary,
                  ),
                  colorScheme: ColorScheme.fromSwatch(primarySwatch: AppMaterialColors.primary)
                      .copyWith(secondary: AppColors.primary)),
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

final navigator = VxNavigator(routes: {
  '/': (_, __) => MaterialPage(child: ProfileScreen()),
  Routes.editProfile: (_, __) => MaterialPage(child: EditProfileScreen()),
  Routes.login: (_, __) => MaterialPage(child: LoginScreen()),
  Routes.pass: (_, param) => MaterialPage(child: PasswordScreen(),arguments: param),
  Routes.verify: (_, param) => MaterialPage(child: VerifyScreen(),arguments: param),
  Routes.register: (_, param) => MaterialPage(child: RegisterScreen(),arguments: param),
  Routes.foodList: (_, __) => MaterialPage(child: FoodListPage()),
});
