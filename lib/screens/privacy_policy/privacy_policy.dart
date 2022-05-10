import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewx/webviewx.dart' as webViewForWeb;

class PrivacyPolicy extends StatefulWidget {
  ShowInboxItem() {}

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends ResourcefulState<PrivacyPolicy> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb && Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      appBar: Toolbar(titleBar: intl.privacyPolicy),
      body: Container(
        color: Color.fromARGB(255, 245, 245, 245),
        padding: EdgeInsets.only(
          left: 3.w,
          top: 3.w,
          right: 3.w,
          bottom: 3.w,
        ),
        child: kIsWeb
                ? webViewForWeb.WebViewX(
                    initialContent: FlavorConfig.instance.variables['urlTerms'],
                    javascriptMode: webViewForWeb.JavascriptMode.unrestricted,
                    width: 100.w,
                    height: 100.h,
                    initialSourceType: webViewForWeb.SourceType.url,
                  )
                : WebView(
                    initialUrl: FlavorConfig.instance.variables['urlTerms'],
                    javascriptMode: JavascriptMode.unrestricted,
                    onPageStarted: (val) {
                      debugPrint('$val');
                    },
                  ),
      ),
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
