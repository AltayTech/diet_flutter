import 'dart:io';

import 'package:behandam/data/entity/ticket/ticket_item.dart';
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

}
