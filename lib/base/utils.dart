import 'dart:io';

import 'package:behandam/data/entity/regime/regime_type.dart';
import 'package:behandam/data/entity/shop/shop_model.dart';
import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static void getSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  static bool checkExistFile(String? name, String tempDir) {
    bool exist = File("${tempDir}/$name").existsSync();
    return exist;
  }

  static TypeTicketItem checkFile(String url) {
    var split = url.split(".");

    if (split[split.length - 1].contains("mp4")) {
      return TypeTicketItem.VIDEO;
    } else if (split[split.length - 1].contains("mp3")) {
      return TypeTicketItem.VOICE;
    } else if (split[split.length - 1].contains("jpg") ||
        split[split.length - 1].contains("png") ||
        split[split.length - 1].contains("jpeg")) {
      return TypeTicketItem.IMAGE;
    } else {
      return TypeTicketItem.FILE;
    }
  }

  static Color getColor(RegimeAlias? alias) {
    switch (alias) {
      case RegimeAlias.WeightLoss:
        return AppColors.looseType;
      case RegimeAlias.WeightGain:
        return AppColors.gainType;

      case RegimeAlias.Stabilization:
        return AppColors.stableType;
      case RegimeAlias.Diabeties:
        return AppColors.diabeticType;

      case RegimeAlias.Pregnancy:
        return AppColors.pregnantType;

      case RegimeAlias.Ketogenic:
        return AppColors.ketogenicType;

      case RegimeAlias.Sport:
        return AppColors.sportType;

      case RegimeAlias.Notrica:
        return AppColors.notricaType;

      default:
        return AppColors.gainType;
    }
  }

  static String getIcon(RegimeAlias? alias) {
    switch (alias) {
      case RegimeAlias.WeightLoss:
        return 'assets/images/diet/loose_weight.svg';
      case RegimeAlias.WeightGain:
        return 'assets/images/diet/gain_weight.svg';

      case RegimeAlias.Stabilization:
        return 'assets/images/diet/fix_weight.svg';
      case RegimeAlias.Diabeties:
        return 'assets/images/diet/diabetes_diet.svg';

      case RegimeAlias.Pregnancy:
        return 'assets/images/diet/pregnant_diet.svg';

      case RegimeAlias.Ketogenic:
        return 'assets/images/diet/loose_weight.svg';

      case RegimeAlias.Sport:
        return 'assets/images/diet/gain_weight.svg';

      case RegimeAlias.Notrica:
        return 'assets/images/diet/notrica.svg';

      default:
        return 'assets/images/diet/gain_weight.svg';
    }
  }

  static String productIcon(TypeMediaShop? state) {
    switch (state) {
      case TypeMediaShop.downloadAndPlay:
        return 'assets/images/shop/download.svg';

      case TypeMediaShop.lock:
        return 'assets/images/shop/lock.svg';

      case TypeMediaShop.play:
        return 'assets/images/shop/play.svg';

      default:
        return 'assets/images/shop/lock.svg';
    }
  }

  static Color getColorPackage(int index) {
    return AppColors.colorPackages[index % 2]['barColor']!;
  }

  static Color getColorPackagePrice(int index) {
    return AppColors.colorPackages[index % 2]['priceColor']!;
  }

  static void launchURL(String url) async {
    // url = Uri.encodeFull(url).toString();
    if (await canLaunch(url)) {
      print('can launch');
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      // throw 'Could not launch $url';
      print('url lanuch error');
    }
  }

  static Future<String> versionApp() async {
    var package = await PackageInfo.fromPlatform();
    return package.version;
  }

  static Future<int> buildNumber() async {
    if (kIsWeb) {
      return 341;
    } else {
      var package = await PackageInfo.fromPlatform();
      return int.parse(package.buildNumber);
    }
  }

  static Future<String> packageName() async {
    if (kIsWeb) {
      return "web.kermany.behandam";
    } else {
      var package = await PackageInfo.fromPlatform();
      return package.packageName;
    }
  }
}
