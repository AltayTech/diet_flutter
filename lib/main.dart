import 'package:behandam/entry_point.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

Future<void> main() async {
  FlavorConfig(
    color: Colors.green,
    name: 'Preview',
    variables: {
      'baseUrl': 'https://user.drkermanidiet.com/behandam-diet/api',
      'baseUrlCrm': 'https://crm.drdietapp.com/api/diet/landings',
      "baseUrlFile": "https://user.drkermanidiet.com/behandam-diet/api/helia-service",
      "baseUrlFileShop": "https://user.drkermanidiet.com/shop-service",
      "iappsPackage": "com.kermanydiet",
      "sibappPackage": "com.kermanydiet",
      'isProduction': false
    },
  );
  await entryPoint();
}
