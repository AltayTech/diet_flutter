import 'dart:io';

import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/utility/intent.dart';
import 'package:behandam/screens/widget/progress.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/deep_link.dart';
import 'package:behandam/utils/image.dart';
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
    if (!kIsWeb && Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    bloc = ProfileBloc();
  }

  bool isInit = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!isInit) {
      isInit = true;
      inboxId = int.parse(ModalRoute.of(context)!.settings.arguments as String);
      bloc.seenInbox(inboxId);
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
                child: (inboxItem.data!.actionType == null ||
                        (inboxItem.data!.actionType == INBOX_ACTION_TYPE.OPEN_INSTAGRAM_PAGE ||
                            inboxItem.data!.actionType == INBOX_ACTION_TYPE.OPEN_TELEGRAM_CHANNEL ||
                            inboxItem.data!.actionType == INBOX_ACTION_TYPE.OPEN_PAGE))
                    ? GestureDetector(
                        child: Card(
                          margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            constraints: BoxConstraints(minHeight: 15.h),
                            child: Row(
                              textDirection: context.textDirectionOfLocale,
                              children: [
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.loose,
                                  child: Container(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        Flexible(
                                          flex: 0,
                                          child: Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                                            child: Text(
                                              inboxItem.data?.title ?? '',
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: double.maxFinite,
                                            padding: EdgeInsets.only(right: 8, left: 8, bottom: 8),
                                            child: Text(
                                              inboxItem.data?.text ?? '',
                                              textAlign: TextAlign.start,
                                              style: Theme.of(context).textTheme.subtitle2,
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                            flex: 0,
                                            child: Padding(
                                              padding: EdgeInsets.all(6),
                                              child: Divider(
                                                height: 0.7,
                                                color: Color(0xffE4E4E7),
                                              ),
                                            )),
                                        Flexible(
                                          flex: 1,
                                          child: Container(
                                            width: double.maxFinite,
                                            height: 5.h,
                                            padding: EdgeInsets.all(8),
                                            child: Row(
                                              textDirection: context.textDirectionOfLocale,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                ImageUtils.fromLocal(
                                                  "assets/images/ticket/date_time.svg",
                                                  color: inboxItem.data?.seenAt == null
                                                      ? Color(0xffA7A9B4)
                                                      : Color(0xffA7A9B4).withOpacity(0.7),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(left: 8, right: 8),
                                                  child: Text(
                                                      inboxItem.data?.createdAt == null
                                                          ? ''
                                                          : DateTimeUtils.getTime(
                                                              inboxItem.data!.createdAt!),
                                                      textAlign: TextAlign.center,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .button!
                                                          .copyWith(
                                                              color: Color(0xffA7A9B4)
                                                                  .withOpacity(0.7))),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    inboxItem.data!.inbox?.createdAt == null
                                                        ? ''
                                                        : DateTimeUtils.gregorianToJalali(inboxItem
                                                            .data!.createdAt!
                                                            .substring(0, 10)),
                                                    textAlign: TextAlign.start,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .button!
                                                        .copyWith(
                                                            color:
                                                                Color(0xffA7A9B4).withOpacity(0.7)),
                                                  ),
                                                ),
                                                Text(
                                                  intl.view,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .button!
                                                      .copyWith(color: AppColors.accentColor),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios_outlined,
                                                  color: AppColors.accentColor,
                                                  size: 18,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 12, right: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (inboxItem.data!.action != null)
                            switch (inboxItem.data!.actionType!) {
                              case INBOX_ACTION_TYPE.OPEN_WEB_URL:
                                IntentUtils.launchURL(inboxItem.data!.action!);
                                break;
                              case INBOX_ACTION_TYPE.OPEN_ESPECIAL_APP:
                                IntentUtils.openApp(inboxItem.data!.action!);
                                break;
                              case INBOX_ACTION_TYPE.OPEN_PAGE:
                                DeepLinkUtils.navigateDeepLink(inboxItem.data!.action!);
                                break;
                              case INBOX_ACTION_TYPE.OPEN_TELEGRAM_CHANNEL:
                                IntentUtils.launchURL(inboxItem.data!.action!);
                                break;
                              case INBOX_ACTION_TYPE.OPEN_INSTAGRAM_PAGE:
                                IntentUtils.launchURL(inboxItem.data!.action!);
                                break;
                              case INBOX_ACTION_TYPE.CALL_SERVICE:
                                // TODO: Handle this case.
                                break;
                            }
                        },
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
        });
  }
}
