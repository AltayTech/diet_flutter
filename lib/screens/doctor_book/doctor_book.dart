import 'dart:async';

import 'package:behandam/base/resourceful_state.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DoctorBookPage extends StatefulWidget {
  const DoctorBookPage({Key? key}) : super(key: key);

  @override
  State<DoctorBookPage> createState() => _DoctorBookPageState();
}

class _DoctorBookPageState extends ResourcefulState<DoctorBookPage> {
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    //loadBook();
  }

  /*Future<void> loadBook() async {
    _epubController = EpubController(
      // Load document
      document: EpubDocument.openData(await InternetFile.get(
          'https://user.drkermanidiet.com/user/video/badinin.epub')),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        // Show table of contents
        /*drawer: Drawer(
          child: EpubViewTableOfContents(
            controller: _epubController,
          ),
        ),*/
        // Show epub document
        body: WebView(
          initialUrl: 'https://user.drkermanidiet.com/user/video/badinin.epub',
          allowsInlineMediaPlayback: true,
          initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);

            _webViewController = webViewController;
          },
          onProgress: (int progress) {
            debugPrint('WebView is loading (progress : $progress%)');
          },
          navigationDelegate: (NavigationRequest request) {
            debugPrint('request ${request.toString()}');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) async {
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (error) {
            debugPrint('web resource error: ${error.toString()}');
          },
          gestureNavigationEnabled: true,
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
