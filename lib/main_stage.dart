import 'package:behandam/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://behaminplus.ir/behandam-diet/api',
      "baseUrlFile": "https://behaminplus.ir/helia-service",
      "baseUrlFileShop": "https://behaminplus.ir/shop-service",
      "urlTerms": "https://debug.behaminplus.ir/#/article/5918",
      "urlPrivacy": "https://debug.behaminplus.ir/#/article/5901",
      "iappsPackage": "com.kermany.behandam-iapps",
      "sibappPackage": "com.kermany.behandam-sibapp",
      'isProduction': true,
      'isCafeBazaar': false,
      'market': Market.google.value
    },
  );
  await entryPoint();
}
