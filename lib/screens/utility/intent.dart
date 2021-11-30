import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart' as urlLauncher;
import 'package:share_plus/share_plus.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

abstract class IntentUtils {
  static Future<void> launchUrl(BuildContext context, String url) {
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

  static Future<void> openStore() async {
    String appId = (await PackageInfo.fromPlatform()).packageName;
    // OpenStore.instance.open(appStoreId: appId, androidAppBundleId: appId);
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
