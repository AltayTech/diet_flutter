import 'package:behandam/app/app.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

import '../entry_point.dart';
import '../routes.dart';


abstract class DeepLinkUtils {
  static void navigateDeepLink(String deeplink) {
    final context = navigator.navigatorKey!.currentContext;
    if (context != null) {
      // app is in foreground, navigate to specified link
     // debugPrint('Deeplink => navigating $deeplink');
      final route = generateRoute(deeplink);
      debugPrint('Deeplink => navigating $route');
      if (route == Routes.splash) return; // deeplink is corrupt
      AppSharedPreferences.setDeeplink(null);
      debugPrint('Deeplink => navigating $route');
     navigator.routeManager.clearAndPush(Uri.parse(route));
    } else {
      // app was in background, postpone navigation until we reach home page
      debugPrint('Deeplink => postponing until home page is appeared $deeplink');
      AppSharedPreferences.setDeeplink(deeplink);
      navigator.routeManager.clearAndPush(Uri.parse(Routes.splash));
    }
  }

  static bool isDeepLink(String? url) {
    if (url == null) return false;
    return url.startsWith('/link/') ||
        url.startsWith('behandam://behandam.app/link/') ||
        url.startsWith('https://behandam.kermany.com/link/');
  }

  static String generateRoute(String deeplink) {
    print('deeplinkRoute = > $deeplink');
    final uri = deeplink.split('/link').last;
    print('deeplinkRoute = > $uri');
    final uriParts = uri.split('?');
    print('deeplinkRoute = > $uriParts');
    final routeName = routeNameOf(uriParts[0]);
  //  final queryPart = (uriParts.length == 2 ? uriParts[1] : '').toLowerCase();
  //  FirebaseCrashlytics.instance.setCustomKey('deeplink', deeplink);
   // final queryParams = Uri.splitQueryString(queryPart);
   // final args = argumentOf(routeName, queryParams);
    return routeName;
   /* return MaterialPageRoute(
      builder: Routes.all[routeName]!,
      settings: RouteSettings(name: routeName, arguments: args),
    );*/
  }

  static String routeNameOf(String deeplinkRoute) {
    debugPrint('deeplinkRoute = > $deeplinkRoute');
    return deeplinkRoute;
   /* if (navigator.routeManager.uris.contains(Uri.parse(deeplinkRoute))) {
      // deeplinkRoute is in our route list

    } else {
      // deeplinkRoute is corrupt
      return Routes.splash;
    }*/
  }

  static Object? argumentOf(String routeName, Map<String, String> queryParams) {
    switch (routeName) {
     /* case Routes.dietActivities:
        return DietActivitiesArgs.fromParams(queryParams);
      case Routes.dietMeals:
        return DietMealsArgs.fromParams(queryParams);
      case Routes.preference:
        return PreferenceArgs.fromParams(queryParams);
      case Routes.checkoutSuccess:
        return CheckoutSuccessArgs.fromParams(queryParams);
      case Routes.preferenceReport:
        return PreferenceReportArgs.fromParams(queryParams);
      case Routes.goal:
        return GoalArgs.fromParams(queryParams);
      case Routes.hateFood:
        return HateFoodArgs.fromParams(queryParams);
      case Routes.water:
        return WaterArgs.fromParams(queryParams);
      case Routes.foodDetail:
        return FoodDetailArgs.fromParams(queryParams);
      case Routes.activityDetail:
        return ActivityDetailArgs.fromParams(queryParams);
      case Routes.blogDetail:
        return BlogDetailArgs.fromParams(queryParams);
      case Routes.ticketDetail:
        return TicketDetailArgs.fromParams(queryParams);*/
      // todo: to support this page we need to add foods to meal inside food-listing page
      // case Routes.foodListing:
      //   return FoodListingArgs.fromParams(queryParams);
    }
  }
}
