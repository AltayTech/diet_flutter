import 'package:behandam/extensions/build_context.dart';
import 'package:flutter/material.dart';
import 'package:logifan/extensions/build_context.dart';


abstract class ResourcefulState <T extends StatefulWidget> extends State<T> {
  late AppLocalizations intl;
  late TextTheme typography;

  @override
  @mustCallSuper
  Widget build(BuildContext context) {
    intl = context.intl;
    typography = context.typography;

    return Text('Not implemented body');
  }
}