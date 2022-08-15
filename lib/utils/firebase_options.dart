import 'dart:io';

import 'package:behandam/base/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseConfig {
  static Future<FirebaseOptions> get platformOptions async {
    if (kIsWeb) {
      // Web
      return const FirebaseOptions(
          apiKey: "AIzaSyBnqcxB9tpxsOu9PNKTvd0OuXi7k7zx0NE",
          authDomain: "behandam-test.firebaseapp.com",
          projectId: "behandam-test",
          storageBucket: "behandam-test.appspot.com",
          messagingSenderId: "343455511841",
          appId: "1:343455511841:web:19fc501195f6b0c1567a60",
          measurementId: "G-7FGHS67SXD");
    } else if (Platform.isIOS || Platform.isMacOS) {
      // iOS and MacOS
      return const FirebaseOptions(
        appId: '1:448618578101:ios:0b650370bb29e29cac3efc',
        apiKey: 'AIzaSyAgUhHU8wSJgO5MVNy95tMT07NEjzMOfz0',
        projectId: 'react-native-firebase-testing',
        messagingSenderId: '448618578101',
        iosBundleId: 'io.flutter.plugins.firebasecoreexample',
      );
    } else {
      // Android
      var value = await Utils.packageName();
      debugPrint('pack => $value');
      if (value.contains('debug')) {
        return const FirebaseOptions(
          appId: '1:343455511841:android:8d44939289a797f6567a60',
          apiKey: 'AIzaSyBMyp8Nw-9A2oYTRSg22M96hP0etHgPVyI',
          projectId: 'behandam-test',
          messagingSenderId: '343455511841',
        );
      } else if (value.contains('develop')) {
        return const FirebaseOptions(
          appId: '1:343455511841:android:72d854e3145a7d82567a60',
          apiKey: 'AIzaSyBMyp8Nw-9A2oYTRSg22M96hP0etHgPVyI',
          projectId: 'behandam-test',
          messagingSenderId: '343455511841',
        );
      } else if (value.contains('stage')) {
        return const FirebaseOptions(
          appId: '1:343455511841:android:5802d7ca9ef7c3be567a60',
          apiKey: 'AIzaSyBMyp8Nw-9A2oYTRSg22M96hP0etHgPVyI',
          projectId: 'behandam-test',
          messagingSenderId: '343455511841',
        );
      } else {
        return const FirebaseOptions(
          appId: '1:343455511841:android:332a06c700201cfb567a60',
          apiKey: 'AIzaSyBMyp8Nw-9A2oYTRSg22M96hP0etHgPVyI',
          projectId: 'behandam-test',
          messagingSenderId: '343455511841',
        );
      }
    }
  }
}
