import 'package:behandam/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://behandam.kermany.com/behandam-diet/api',
      "baseUrlFile": "https://behandam.kermany.com/helia-service",
      "baseUrlFileShop": "https://behandam.kermany.com/shop-service",
      "iappsPackage": "com.kermany.behandam-iapps",
      "sibappPackage": "com.kermany.behandam-sibapp",
      'isProduction': false
    },
  );
  await entryPoint();
}
