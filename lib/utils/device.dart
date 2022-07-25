import 'dart:io';
import 'dart:math' as Math;
import 'dart:ui' as ui;

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:logifan/extensions/string.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class DeviceUtils {
  static String get platform {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'IOS';
    }
    return 'Unknown';
  }

  static Future<String> get platformVersion async {
    return await _getDeviceInfo(
      (androidInfo) => androidInfo.version.sdkInt!.toString(),
      (iosInfo) => iosInfo.systemVersion!,
      (webDeviceInfo) => webDeviceInfo.hardwareConcurrency.toString(),
    );
  }

  static Future<String> get deviceId async {
    return await _getDeviceInfo(
      (androidInfo) => androidInfo.androidId ?? androidInfo.id ?? '',
      (iosInfo) => iosInfo.identifierForVendor!,
      (webDeviceInfo) => webDeviceInfo.vendor!,
    );
  }

  static Future<String> get deviceName async {
    return await _getDeviceInfo(
      (androidInfo) =>
          '${androidInfo.brand!.capitalize()} ${androidInfo.model} ${androidInfo.device}',
      (iosInfo) => iosInfo.name!,
      (webDeviceInfo) => webDeviceInfo.userAgent!,
    );
  }

  static Future<bool> get isEmulator async {
    final String isPhysical = await _getDeviceInfo(
      (androidInfo) => androidInfo.isPhysicalDevice.toString(),
      (iosInfo) => iosInfo.isPhysicalDevice.toString(),
      (webDeviceInfo) => webDeviceInfo.userAgent.toString(),
    );
    if (isPhysical == 'true') {
      return false;
    }
    return true;
  }

  static Future<String> makeUserAgent() async {
    String userAgent = '';
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appVersion = packageInfo.version;
    // print('userAgent $appName / $packageName / $appVersion / $buildNumber');
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      final webBrowserInfo = await deviceInfo.webBrowserInfo;
      userAgent = 'Behandam/$appVersion (Web/${webBrowserInfo.userAgent})';
    } else if (Platform.isIOS) {
      print('is ios');
      var iosInfo = await deviceInfo.iosInfo;
      var systemName = iosInfo.systemName;
      var iosVersion = iosInfo.systemVersion;
      var name = iosInfo.name;
      userAgent =
          'Behandam/${FlavorConfig.instance.variables['market']}/$appVersion{${packageInfo.buildNumber}} $systemName/$iosVersion (Apple/${iosInfo.utsname.machine})';
      print('user agent $userAgent');
    } else if (Platform.isAndroid) {
      var androidInfo = await deviceInfo.androidInfo;
      var release = androidInfo.version.release;
      var model = androidInfo.model;
      var brand = androidInfo.brand;
      userAgent =
          'Behandam/${FlavorConfig.instance.variables['market']}/$appVersion Android/$release ($brand/$model)';
      print('user agent $userAgent');
    }
    return userAgent;
  }

  static Future<String> _getDeviceInfo(
    String Function(AndroidDeviceInfo) androidDeviceInfo,
    String Function(IosDeviceInfo) iosDeviceInfo,
    String Function(WebBrowserInfo) webDeviceInfo,
  ) async {
    final deviceInfo = DeviceInfoPlugin();
    var identifier = 'null';
    if (kIsWeb) {
      final webBrowserInfo = await deviceInfo.webBrowserInfo;
      identifier = webDeviceInfo.call(webBrowserInfo);
    } else if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      identifier = androidDeviceInfo.call(androidInfo);
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      identifier = iosDeviceInfo.call(iosInfo);
    }
    if (identifier == '') {
      return 'null';
    }
    return identifier;
  }
}

class Device {
  static double devicePixelRatio = ui.window.devicePixelRatio;
  static ui.Size size = ui.window.physicalSize;
  static double width = size.width;
  static double height = size.height;
  static double screenWidth = width / devicePixelRatio;
  static double screenHeight = height / devicePixelRatio;
  static ui.Size screenSize = new ui.Size(screenWidth, screenHeight);
  final bool isTablet, isPhone, isIos, isAndroid, isIphoneX, hasNotch;
  static Device? _device;
  static Function? onMetricsChange;

  Device({
    required this.isTablet,
    required this.isPhone,
    required this.isIos,
    required this.isAndroid,
    required this.isIphoneX,
    required this.hasNotch,
  });

  factory Device.get() {
    if (_device != null) return _device!;

    if (onMetricsChange == null) {
      onMetricsChange = ui.window.onMetricsChanged;
      ui.window.onMetricsChanged = () {
        _device = null;

        size = ui.window.physicalSize;
        width = size.width;
        height = size.height;
        screenWidth = width / devicePixelRatio;
        screenHeight = height / devicePixelRatio;
        screenSize = new ui.Size(screenWidth, screenHeight);

        onMetricsChange!();
      };
    }

    bool isTablet;
    bool isPhone;
    bool isIos = kIsWeb ? false : Platform.isIOS;
    bool isAndroid = kIsWeb ? false : Platform.isAndroid;
    bool isIphoneX = false;
    bool hasNotch = false;

    if (devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
      isPhone = false;
    } else if (devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      isPhone = false;
    } else {
      isTablet = false;
      isPhone = true;
    }

    // Recalculate for Android Tablet using device inches
    if (isAndroid) {
      final adjustedWidth = _calWidth() / devicePixelRatio;
      final adjustedHeight = _calHeight() / devicePixelRatio;
      final diagonalSizeInches =
          (Math.sqrt(Math.pow(adjustedWidth, 2) + Math.pow(adjustedHeight, 2))) / _ppi;
      if (diagonalSizeInches >= 7) {
        isTablet = true;
        isPhone = false;
      } else {
        isTablet = false;
        isPhone = true;
      }
    }

    if (isIos &&
        isPhone &&
        (screenHeight == 812 ||
            screenWidth == 812 ||
            screenHeight == 896 ||
            screenWidth == 896 ||
            // iPhone 12 pro
            screenHeight == 844 ||
            screenWidth == 844 ||
            // Iphone 12 pro max
            screenHeight == 926 ||
            screenWidth == 926)) {
      isIphoneX = true;
      hasNotch = true;
    }

    if (_hasTopOrBottomPadding()) hasNotch = true;

    return _device = new Device(
        isTablet: isTablet,
        isPhone: isPhone,
        isAndroid: isAndroid,
        isIos: isIos,
        isIphoneX: isIphoneX,
        hasNotch: hasNotch);
  }

  static double _calWidth() {
    if (width > height)
      return (width + (ui.window.viewPadding.left + ui.window.viewPadding.right) * width / height);
    return (width + ui.window.viewPadding.left + ui.window.viewPadding.right);
  }

  static double _calHeight() {
    return (height + (ui.window.viewPadding.top + ui.window.viewPadding.bottom));
  }

  static int get _ppi {
    if (kIsWeb) {
      return 96;
    } else if (Platform.isAndroid) {
      return 160;
    } else if (Platform.isIOS) {
      return 150;
    }
    return 96;
  }

  static bool _hasTopOrBottomPadding() {
    final padding = ui.window.viewPadding;
    return padding.top > 0 || padding.bottom > 0;
  }
}
