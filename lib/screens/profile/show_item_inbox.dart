import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webviewx/webviewx.dart' as webViewForWeb;

class ShowInboxItem extends StatefulWidget {
  ShowInboxItem() {}

  @override
  State<ShowInboxItem> createState() => _ShowInboxItemState();
}

class _ShowInboxItemState extends ResourcefulState<ShowInboxItem> {
  late ProfileBloc bloc;

  late int inboxId;
  var result;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!kIsWeb && Platform.isAndroid)
      WebView.platform = SurfaceAndroidWebView();

    bloc = ProfileBloc();
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      inboxId = (ModalRoute
          .of(context)!
          .settings
          .arguments as int);

      bloc.getInboxMessage(inboxId);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return body();
  }

  Widget body() {
    return StreamBuilder<InboxItem?>(
        stream: bloc.inboxItem,
        builder: (context, inboxItem) {
          if (inboxItem.hasData)
            return Scaffold(
              backgroundColor: Color.fromARGB(255, 245, 245, 245),
              appBar: Toolbar(titleBar: inboxItem.data!.title ?? ''),
              body: Container(
                color: Color.fromARGB(255, 245, 245, 245),
                padding: EdgeInsets.only(
                  left: 3.w,
                  top: 3.w,
                  right: 3.w,
                  bottom: 3.w,
                ),
                child: (inboxItem.data!.actionType == null)
                    ? Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 3.5.w, vertical: 3.5.w),
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.0),
                    color: Colors.white,
                  ),
                  child: Text(
                    inboxItem.data!.text ?? intl.messageNotFound,
                    textAlign: TextAlign.start,
                    textDirection: context.textDirectionOfLocale,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyText2,
                  ),
                )
                    : kIsWeb
                    ? webViewForWeb.WebViewX(
                  initialContent: inboxItem.data!.action! + '?from=app',
                  javascriptMode: webViewForWeb.JavascriptMode.unrestricted,
                  width: 100.w,
                  height: 100.h,
                  initialSourceType: webViewForWeb.SourceType.url,
                )
                    : WebView(
                  initialUrl: inboxItem.data!.action! + '?from=app',
                  javascriptMode: JavascriptMode.unrestricted,
                  onPageStarted: (val) {
                    debugPrint('$val');
                  },
                ),
              ),
            );
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            appBar: Toolbar(titleBar: intl.loading),
            body: Container(
                color: Color.fromARGB(255, 245, 245, 245),
                padding: EdgeInsets.only(
                  left: 3.w,
                  top: 3.w,
                  right: 3.w,
                  bottom: 3.w,
                ),
                child: Center(child: Progress())),
          );
        }
    );
  }
}
