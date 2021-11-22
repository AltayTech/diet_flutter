import 'dart:io';

import 'package:behandam/data/entity/ticket/ticket_item.dart';
import 'package:behandam/themes/colors.dart';
import 'package:flutter/material.dart';

class Utils {
  static void getSnackbarMessage(BuildContext context, String message) {
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

  static Color getColor(String? alias) {
    switch (alias) {
      case "WEIGHT_LOSS":
        return AppColors.looseType;
      case "WEIGHT_GAIN":
        return AppColors.gainType;

      case "STABILIZATION":
        return AppColors.stableType;
      case "DIABETES":
        return AppColors.diabetType;

      case "PREGNANCY":
        return AppColors.pregnantType;

      case "KETOGENIC":
        return AppColors.ketoType;

      case "SPORTS":
        return AppColors.sportType;

      case "NOTRICA":
        return AppColors.notricaType;

      default:
        return AppColors.gainType;
    }
  }

  static String getIcon(String? alias) {
    switch (alias) {
      case "WEIGHT_LOSS":
        return 'assets/images/diet/loose_weight.svg';
      case "WEIGHT_GAIN":
        return 'assets/images/diet/gain_weight.svg';

      case "STABILIZATION":
        return 'assets/images/diet/fix_weight.svg';
      case "DIABETES":
        return 'assets/images/diet/diabetes_diet.svg';

      case "PREGNANCY":
        return 'assets/images/diet/pregnant_diet.svg';

      case "KETOGENIC":
        return 'assets/images/diet/loose_weight.svg';

      case "SPORTS":
        return 'assets/images/diet/gain_weight.svg';

      case "NOTRICA":
        return 'assets/images/diet/notrica.svg';

      default:
        return 'assets/images/diet/gain_weight.svg';
    }
  }

  static Color getColorPackage(int index) {
    return AppColors.colorPackages[index % 2]['barColor']!;
  }

  static Color getColorPackagePrice(int index) {
    return AppColors.colorPackages[index % 2]['priceColor']!;
  }
}
