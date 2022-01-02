import 'package:behandam/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://debug.behaminplus.ir/behandam-diet/api',
      "baseUrlFile": "https://debug.behaminplus.ir/helia-service",
      "baseUrlFileShop": "https://debug.behaminplus.ir/shop-service",
      "urlTerms": "https://debug.behaminplus.ir/#/terms",
      "iappsPackage": "com.kermany.behandam-iapps",
      "sibappPackage": "com.kermany.behandam-sibapp",
      'isProduction': false
    },
  );
  await entryPoint();
}
