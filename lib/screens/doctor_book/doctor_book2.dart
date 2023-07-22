import 'dart:io';

import 'package:behandam/screens/widget/toolbar.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

void main() async {
  runApp(DoctorBookPage2());
}

class DoctorBookPage2 extends StatefulWidget {
  @override
  _DoctorBookPage2State createState() => _DoctorBookPage2State();
}

class _DoctorBookPage2State extends State<DoctorBookPage2> {
  bool loading = false;
  Dio dio = Dio();
  String filePath = "";

  @override
  void initState() {
    download();
    super.initState();
  }

  /// ANDROID VERSION
  Future<void> fetchAndroidVersion() async {
    final int? version = await getAndroidVersion();
    if (version != null) {
      if (version >= 13) {
        await startDownload();
      } else {
        final PermissionStatus status = await Permission.storage.request();
        if (status == PermissionStatus.granted) {
          await startDownload();
        } else {
          await Permission.storage.request();
        }
      }
      print("ANDROID VERSION: $version");
    }
  }

  Future<int> getAndroidVersion() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var sdkInt = androidInfo.version.sdkInt;
      return sdkInt;
    }
    return 0;
  }

  download() async {
    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        await startDownload();
      } else {
        await Permission.storage.request();
      }
    } else if (Platform.isAndroid) {
      await fetchAndroidVersion();
    } else {
      PlatformException(code: '500');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: Toolbar(titleBar: ''),
        body: Center(
          child: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    Text('Downloading.... E-pub'),
                  ],
                )
              : Container(),
        ),
      ),
    );
  }

  startDownload() async {
    setState(() {
      loading = true;
    });
    Directory? appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();

    String path = appDocDir!.path + '/sample2.epub';
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        "https://user.drkermanidiet.com/user/video/badinin.epub",
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          print('Download --- ${(receivedBytes / totalBytes) * 100}');
          setState(() {
            loading = true;
          });
        },
      ).whenComplete(() {
        setState(() {
          loading = false;
          filePath = path;
          VocsyEpub.open(
            filePath,
          );
        });
      });
    } else {
      setState(() {
        loading = false;
        filePath = path;
        VocsyEpub.open(
          filePath,
        );
      });
    }
  }
}
