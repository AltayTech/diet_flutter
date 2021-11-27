import 'package:behandam/base/resourceful_state.dart';
import 'package:behandam/data/entity/user/inbox.dart';
import 'package:behandam/routes.dart';
import 'package:behandam/screens/profile/profile_bloc.dart';
import 'package:behandam/screens/widget/toolbar.dart';
import 'package:behandam/screens/widget/widget_box.dart';
import 'package:behandam/themes/colors.dart';
import 'package:behandam/utils/date_time.dart';
import 'package:behandam/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:velocity_x/velocity_x.dart';

class InboxList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _InboxList();
}

class _InboxList extends ResourcefulState<InboxList> {
  late ProfileBloc profileBloc;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profileBloc = ProfileBloc();
    profileBloc.getInbox();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: Toolbar(titleBar: intl.inbox),
      backgroundColor: Color.fromARGB(255, 245, 245, 245),
      body: StreamBuilder(
        builder: (context, AsyncSnapshot<List<InboxItem>> snapshot) {
          print('snap==> ${snapshot.data}');
          if (snapshot.data == null) {
            return Center(
              child: SpinKitCircle(
                size: 5.h,
                color: AppColors.primary,
              ),
            );
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Text(intl.notFoundInbox),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Container(
                      constraints: BoxConstraints(minHeight: 15.h),
                      child: Row(
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
                                      alignment: Alignment.topRight,
                                      width: double.maxFinite,
                                      padding: EdgeInsets.only(left: 8, top: 8, right: 8),
                                      child: Text(
                                        snapshot.data![index].inbox.title ?? '',
                                        textAlign: TextAlign.right,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  Flexible(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      width: double.maxFinite,
                                      padding: EdgeInsets.only(right: 8, left: 8, bottom: 8),
                                      child: Text(
                                        snapshot.data![index].inbox.text ?? '',
                                        textAlign: TextAlign.right,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                      alignment: Alignment.centerRight,
                                      width: double.maxFinite,
                                      height: 5.h,
                                      padding: EdgeInsets.all(8),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back_ios_rounded,
                                            color: AppColors.accentColor,
                                            size: 18,
                                          ),
                                          Text(
                                            "مشاهده بیشتر",
                                            style: TextStyle(color: AppColors.accentColor),
                                            textAlign: TextAlign.center,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              snapshot.data![index].inbox.createdAt == null
                                                  ? ''
                                                  : DateTimeUtils.gregorianToJalali(snapshot
                                                      .data![index].inbox.createdAt!
                                                      .substring(0, 10)),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  color: snapshot.data![index].seenAt == null
                                                      ? Color(0xffA7A9B4)
                                                      : Color(0xffA7A9B4).withOpacity(0.7)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(left: 8, right: 8),
                                            child: Text(
                                              snapshot.data![index].inbox.createdAt == null
                                                  ? ''
                                                  : DateTimeUtils.getTime(
                                                      snapshot.data![index].inbox.createdAt!),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: snapshot.data![index].seenAt == null
                                                      ? Color(0xffA7A9B4)
                                                      : Color(0xffA7A9B4).withOpacity(0.7)),
                                            ),
                                          ),
                                          ImageUtils.fromLocal(
                                            "assets/images/ticket/date_time.svg",
                                            color: snapshot.data![index].seenAt == null
                                                ? Color(0xffA7A9B4)
                                                : Color(0xffA7A9B4).withOpacity(0.7),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.only(left: 12, right: 12),
                            ),
                          ),
                          snapshot.data![index].seenAt == null
                              ? Flexible(
                                  flex: 0,
                                  child: Container(
                                      width: 7.w,
                                      height: 17.5.h,
                                      decoration: BoxDecoration(
                                          color: AppColors.accentColor,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10))),
                                      child: new RotatedBox(
                                        quarterTurns: 1,
                                        child: Center(
                                          child: new Text(
                                            'پیام جدید',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      )),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    snapshot.data![index].inbox.id = snapshot.data![index].id;
                    setState(() {
                      snapshot.data![index].seenAt = DateTime.now().toString();
                    });
                    if (snapshot.data![index].inbox.actionType == null ||
                        (snapshot.data![index].inbox.actionType ==
                                INBOX_ACTION_TYPE.OPEN_INSTAGRAM_PAGE.index ||
                            snapshot.data![index].inbox.actionType ==
                                INBOX_ACTION_TYPE.OPEN_TELEGRAM_CHANNEL.index ||
                            snapshot.data![index].inbox.actionType ==
                                INBOX_ACTION_TYPE.OPEN_WEB_URL.index))
                      VxNavigator.of(context)
                          .push(Uri.parse(Routes.showInbox), params: snapshot.data![index].inbox);
                    else
                      launchURL(snapshot.data![index].inbox.action);
                  },
                );
              },
            );
          }
        },
        stream: profileBloc.inboxStream,
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
