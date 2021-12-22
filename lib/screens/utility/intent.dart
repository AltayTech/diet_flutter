import 'package:android_intent/android_intent.dart';
import 'package:behandam/utils/device.dart';
import 'package:behandam/utils/file.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:open_store/open_store.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:share_plus/share_plus.dart';

abstract class IntentUtils {
  static Future<void> launchCustomTabs(BuildContext context, String url) {
    return launch(
      url,
      customTabsOption: CustomTabsOption(
        toolbarColor: Theme.of(context).primaryColor,
        enableDefaultShare: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        extraCustomTabs: const <String>[
          // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
          'org.mozilla.firefox',
          // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
          'com.microsoft.emmx',
        ],
      ),
      safariVCOption: SafariViewControllerOption(
        preferredBarTintColor: Theme.of(context).primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: false,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }

  static void launchURL(String url) async {
    if (await urlLauncher.canLaunch(url)) {
      await urlLauncher.launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static Future<void> openStore([String? package]) async {
    String appId = package ?? (await PackageInfo.fromPlatform()).packageName;
    OpenStore.instance.open(appStoreId: appId, androidAppBundleId: appId);
  }

  static void openInstagram(String data) async {
    if (Device.get().isAndroid) {
      try {
        AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          package: "com.instagram.android",
          data: data, // eg. https://www.instagram.com/_u/zirehapp/
        );
        await intent.launch();
      } catch (ActivityNotFoundException) {
        debugPrint("can't open url");
        launchURL(data);
      }
    } else {
      launchURL(data);
    }
  }

  static void openAppIntent(String data) async {
    if (Device.get().isAndroid) {
      try {
        AndroidIntent intent = AndroidIntent(
          action: 'action_view',
          data: data, // eg. tel:02531234567
        );
        await intent.launch();
      } catch (ActivityNotFoundException) {
        debugPrint("can't open url");
      }
    } else {
      throw 'Platform not supported for Intent : $data';
    }
  }

  static void openApp(String package) async {
    if (Device.get().isAndroid) {
      try {
        bool isInstalled = await DeviceApps.isAppInstalled(package);
        if (isInstalled) {
          DeviceApps.openApp(package); // eg. com.application.karsu
        }else
          openStore(package);
      } catch (ActivityNotFoundException) {
        debugPrint("can't open app");
        openStore(package);
      }
    } else {
      openStore(package);
    }
  }

  static Future<bool> composeEmail(String mail) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: mail,
    );
    final url = emailLaunchUri.toString();
    final result = await urlLauncher.canLaunch(url);
    if (result) {
      await urlLauncher.launch(url);
      return true;
    } else {
      return false;
    }
  }

  /// Open file in corresponding viewer in system
  static Future<OpenResult> openFile(String fileName) async {
    String path = await FileUtils.filePath(fileName);
   var r= await OpenFile.open(path);
   return r;
  }
  static Future<ResultType> openFilePath(String path) async {
    var r;
    try {
      r = await OpenFile.open(path);
    }catch(e){
      r=ResultType.noAppToOpen;
    }
    return r;
  }
  static Future<void> shareText(String text) async {
    return await Share.share(text);
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }
}
