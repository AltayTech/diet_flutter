import 'dart:io';

import 'package:behandam/data/entity/user/inbox.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ShowInboxItem extends StatefulWidget {
  static const routeName = '/profile/inbox/item';

  ShowInboxItem() {
    /*
    seenInbox();*/
  }

  @override
  State<ShowInboxItem> createState() => _ShowInboxItemState();
}

class _ShowInboxItemState extends State<ShowInboxItem> {
  late InboxItem args;
  var result;

  /*seenInbox() async {
    print('call seen');
    try {
      result = await profileService.seenInbox(widget.item['id']);
    //  print('Seen Inbox json: ${result}');

    } catch (e) {
       print('Seen Inbox json: $e');
    }
    getUnreadInbox();
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }
bool isInit=false;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      args = (ModalRoute
          .of(context)!
          .settings
          .arguments as InboxItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: Container(
        color: Color.fromARGB(255, 245, 245, 245),
        padding: EdgeInsets.only(
          left: 3.w,
          top: 3.w,
          right: 3.w,
          bottom: 3.w,
        ),
        child: (args.actionType == null)
            ? Container(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 3.5.w),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.white,
                ),
                child: Text(
                  args.text ?? 'پیامی برای نمایش وجود ندارد',
                  textAlign: TextAlign.right,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
              )
            : WebView(
                initialUrl: args.action + '?from=app',
                javascriptMode: JavascriptMode.unrestricted,
                onPageStarted: (val) {
                  print('$val');
                },
              ),
      ),
    );
  }
}
