import 'package:behandam/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://develop.behaminplus.ir/behandam-diet/api',
      "baseUrlFile": "https://develop.behaminplus.ir/helia-service",
      'isProduction': false
    },
  );
  await entryPoint();
}
