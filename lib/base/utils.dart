
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Utils {

    static void getSnackbarMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
