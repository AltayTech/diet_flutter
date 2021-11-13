import 'package:flutter/src/gestures/tap.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
class LinkFile extends TextSpan {
  LinkFile({TextStyle? style, String? url, String? text})
      : super(
      style: style,
      text: text ?? url,
      recognizer: new TapGestureRecognizer()
        ..onTap = () {
          launch(url!);
        });
}