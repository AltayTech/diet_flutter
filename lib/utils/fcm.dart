import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:behandam/data/entity/notification.dart';
import 'package:behandam/data/sharedpreferences.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/themes/locale.dart';
import 'package:behandam/utils/deep_link.dart';
import 'package:behandam/utils/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum actionType {
  OpenApp,
  OpenWebUrl,
  OpenEspecialApp,
  OpenPage,
  OpenTelegramChannal,
  OpenInstagramPage,
  CallService
}

class AppFcm {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    _initializeAwesome();
    if (!kIsWeb) _listenAwesomeEvents();
    _registerOnFirebase();
    if (!kIsWeb) _listenFcmEvents();
  }

  static void _listenAwesomeEvents() {
    AwesomeNotifications().actionStream.listen((event) async {
      debugPrint('event = $event');
      ActionsItem? action;
      if (event.buttonKeyPressed == '') {
        // push only tapped, no button is pressed
        final json = await AppSharedPreferences.fcmPushAction;
        debugPrint('json = $json');

        action = json != null ? ActionsItem.fromJson(jsonDecode(json)) : null;
        await AppSharedPreferences.setFcmPushAction(null);
      } else {
        // a button on push is pressed
        final json = await AppSharedPreferences.fcmButtonActions;
        debugPrint('json = $json');
        Notif notif = Notif.fromJson2(jsonDecode(json!));
        action = json != null
            ? notif.actions!.where((element) {
                return element.key == event.buttonKeyPressed;
              }).single
            : null;
        await AppSharedPreferences.setFcmButtonActions(null);
      }
      debugPrint('event = $event');
      debugPrint('action = ${action.toString()}');
      if (action == null) {
        return;
      }
      _handleAction(action);
    });
  }

  static void _handleAction(ActionsItem action) {
    switch (actionType.values[int.parse(action.actionType!)]) {
      case actionType.OpenApp:
        IntentUtils.launchURL(action.action!);
        break;
      case actionType.OpenPage:
        DeepLinkUtils.navigateDeepLink(action.action!);
        break;
      case actionType.OpenEspecialApp:
        IntentUtils.openApp(action.action!);
        break;
      case actionType.OpenEspecialApp:
        IntentUtils.openAppIntent(action.action!);
        break;
      case actionType.OpenInstagramPage:
        IntentUtils.openInstagram(action.action!);
        break;
      case actionType.OpenTelegramChannal:
        IntentUtils.launchURL(action.action!);
        break;

      case actionType.OpenWebUrl:
        IntentUtils.launchURL(action.action!);
        break;
      case actionType.CallService:
        // TODO: Handle this case.
        break;
    }
  }

  static Future<void> _initializeAwesome() async {
    if (kIsWeb) {
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return;
    }

    await AwesomeNotifications().initialize(
      null, // this makes you use your default icon, if you haven't one
      [
        NotificationChannel(
          channelKey: 'campaign',
          channelName: 'campaign',
          channelDescription: 'campaign',
          defaultColor: AppColors.primary,
          ledColor: AppColors.primary,
        ),
        NotificationChannel(
          channelKey: 'behandam',
          channelName: 'behandam',
          channelDescription: 'behandam',
          defaultColor: AppColors.primary,
          ledColor: AppColors.primary,
        ),
      ],
    );
  }

  static void _registerOnFirebase() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    subscribeTopicAll();
    _getToken();
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  static void subscribeTopicAll() async {
    _firebaseMessaging.subscribeToTopic('all');
    final currentLocale = await AppLocale.currentLocale;
    final otherLocales = await AppLocale.otherLocales;
    otherLocales.forEach((locale) {
      _firebaseMessaging.unsubscribeFromTopic('all_${locale.languageCode}');
    });
    _firebaseMessaging.subscribeToTopic('all_${currentLocale.languageCode}');
  }

  static void _getToken() {
    try {
      _firebaseMessaging.getToken().then((token) {
        AppSharedPreferences.setFcmToken(token);
        debugPrint('Your fcm token is: $token');
      });
    } catch (e) {
      debugPrint('Firebase service is not available');
    }
  }

  static void _listenFcmEvents() async {
    FirebaseMessaging.onMessage.listen((event) {
      debugPrint('on message');

      sendNotification(event.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      debugPrint('on message opened app');
      sendNotification(event.data);
    });
  }

  static Future<void> backgroundMessageHandler(RemoteMessage message) async {
    debugPrint('on background message');

    await AppSharedPreferences.initialize();
    await Firebase.initializeApp(
      options: await DefaultFirebaseConfig.platformOptions,
    );
    _listenAwesomeEvents();
    sendNotification(message.data);
  }

  static List<ActionsItem> actionList = [];

  static void sendNotification(Map<String, dynamic> message) async {
    // debugPrint("data >> $message");
    Notif notifResponse = Notif.fromJson(message);
    debugPrint("notifResponse =>> ${notifResponse.toJson()}");
    if (notifResponse.action != null) {
      ActionsItem actionsItem = ActionsItem();
      actionsItem.action = notifResponse.action;
      actionsItem.actionType = notifResponse.actionType;
      await AppSharedPreferences.setFcmPushAction(jsonEncode(actionsItem.toJson()));
    }
    final List<NotificationActionButton> buttonActions = [];
    if (notifResponse.actions != null && notifResponse.actions!.length > 0) {
      int i = 0;
      actionList.clear();
      for (ActionsItem actions in notifResponse.actions!) {
        buttonActions.add(NotificationActionButton(
          key: "10$i",
          label: actions.title ?? '',
          enabled: true,
        ));
        actions.key = "10$i";
        print("actions =>> ${actions.toJson()}");
        actionList.add(actions);
        i++;
      }

      await AppSharedPreferences.setFcmButtonActions(jsonEncode(notifResponse.toJson()));
    }

    if (notifResponse.visible == "true")
      AwesomeNotifications().createNotification(
          content: NotificationContent(
              id: 1,
              channelKey: notifResponse.chanel_id ?? 'com.kermany.behandam',
              displayOnBackground: true,
              title: notifResponse.title,
              body: notifResponse.description,
              customSound: "default",
              largeIcon: notifResponse.icon,
              showWhen: true,
              autoCancel: bool.fromEnvironment(notifResponse.autoCancel!)
              //  autoDismissible: bool.fromEnvironment(notifResponse.autoCancel!)
              ),
          actionButtons: buttonActions);
  }
}
